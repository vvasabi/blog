---
title: Tomcat Auto Failover using Apache & Memcached
cover_image: /images/tomcat-and-memcached.png
date: 2012-12-29
tags: open source, tomcat, memcached, java, apache
---
As a requirement for [Continuous Delivery](http://continuousdelivery.com),
changes to applications should be deployed as frequently as possible. GitHub is
[a well-known example](https://github.com/blog/1241-deploying-at-github): on
their “busiest day,” GitHub “saw 563 builds and 175 deploys.” To achieve this
with a web application, zero-downtime deployment needs to be done to avoid
service disruption.

To achieve zero-downtime deployment, there are several solutions. Both
commercial tools, such as
[LiveRebel](http://zeroturnaround.com/software/liverebel/), and container
features, such as Tomcat 7’s
[parallel deployment](http://tomcat.apache.org/tomcat-7.0-doc/config/context.html#Parallel_deployment), can make this happen. This post focuses on the
approach that uses Apache’s auto failover feature to achieve zero-downtime
deployment by performing round-robin updates on multiple Tomcat instances.

READMORE

In order for auto failover to work seamlessly without users noticing the
redeployments of applications, sessions must be replicated between application
servers. Without session replication, users lose sessions, _i.e._ getting logged
out, as soon as the request is served by a different application server.

Tomcat has built-in facilities, including `DeltaManager` and `BackupManager`,
that enable session replication. In practice, I found both of these complicated
to configure, and I have not been able to maintain sessions with `DeltaManager`
upon auto failover.

As an alternative, I found that
[memcached-session-manager](http://code.google.com/p/memcached-session-manager/)
not only works
great but is also very easy to configure. As a bonus, it offers good performance
and scalability. This post therefore documents the simple steps to set up Tomcat
auto failover using Apache, memcached and memcached-session-manager on a single
machine. In theory, the steps documented here would apply equally well to a
multi-machine clustered environment.

### 1. Set up Tomcat Instances

For auto failover to work, at least 2 Tomcat instances need to be set up. To use
an existing Tomcat installation, just make a copy of it. Otherwise, download it
[from here](http://tomcat.apache.org) and also make 2 copies.

#### a. Install Required Jars

For each copy, download the following jars and install them to the
`tomcat_installation/lib` directory:

* **memcached-session-manager-x.y.z.jar((, [available
  here](http://code.google.com/p/memcached-session-manager/downloads/list)
* **memcached-session-manager-tc7-x.y.z.jar** (for Tomcat 7) or
  **memcached-session-manager-tc6-x.y.z.jar** (for Tomcat 6), [also available
  here](http://code.google.com/p/memcached-session-manager/downloads/list)
* **spymemcached-x.y.z.jar**, [available
  here](http://code.google.com/p/spymemcached/downloads/list)

At the time of this writing, the latest version of memcached-session-manager is
1.6.3 and spymemcached is 2.8.4.

#### b. Tomcat Configurations

For each copy, open `tomcat_installation/conf/context.xml`, and add the
following lines inside the `<Context>` tag:

``` xml
<Manager className="de.javakaffee.web.msm.MemcachedBackupSessionManager"
    memcachedNodes="n1:localhost:11211"
    requestUriIgnorePattern=".*\.(ico|png|gif|jpg|css|js)$" />
```

If you already have a memcached instance setup that is on a different server
and/or listens on a different port, change the value in `memcachedNodes`.
Otherwise, the setting here are the defaults of the memcached instance to be
installed in the step below.

Open `tomcat_installation/conf/server.xml`, look for the following lines:

``` xml
<Server port="8005" ...>
    ...
    <Connector port="8080" protocol="HTTP/1.1" ...>
    ...
    <Connector port="8009" protocol="AJP/1.3" ...>
```

Change the ports, so the two installations listen to different ports. This is
optional, but I would also disable the HTTP/1.1 connector by commenting out its
`<Connector>` tag, as the setup documented here only requires the AJP connector
to be enabled.

Finally, look for this line, also in `tomcat_installation/conf/server.xml`:

``` xml
<Engine name="Catalina" defaultHost="localhost" ...>
```

Add the `jvmRoute` property, and assign it a value, that is different between
the two installations. For example:

``` xml
<Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm1" ...>
```

And, for the second instance:

``` xml
<Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm2" ...>
```

That’s it for Tomcat configuration. This configuration uses
memcached-session-manager’s default serialization strategy and enables sticky
session support. For more configuration options, refer to the links in the
references section.

### 2. Configure Apache

For Apache, open `/etc/httpd/conf/httpd.conf` (for Fedora, CentOS and Red Hat
Enterprise Linux, your distribution may have it elsewhere), add the following
lines:

``` text
<Proxy balancer://cluster>
    BalancerMember ajp://localhost:8009 route=jvm1
    BalancerMember ajp://localhost:8109 route=jvm2
</Proxy>
ProxyPass / balancer://cluster/ stickysession=JSESSIONID|jsessionid
```

These lines may also be placed inside a `VirtualHost` directive. Change the path
if your application does not run on `/`. For example:

``` text
ProxyPass /app/ balancer://cluster/app/ stickysession=JSESSIONID|jsessionid
```

Note that the `BalancerMember` lines point to the ports and `jvmRoute`s
configured in step 1.

This step sets up a load balancer that dispatches web requests to the two Tomcat
installation. When one of the Tomcat instance gets shutdown, requests will be
served by the other one that is still up. As a result, user does not experience
downtime when one of the Tomcat instances is taken down for maintenance or
application redeployment.

This step also sets up sticky session. What this means is that, if user begins
session with instance 1, she would be served by instance 1 throughout the entire
session, unless of course this instance goes down. This can be beneficial in a
clustered environment, as application servers can use session data stored
locally without contacting a remote memcached.

### 3. Install memcached

On Fedora/CentOS/Red Hat Enterprise Linux, memcached can be installed using
`yum install memcached`. If memcached is not available, add
[Remi](http://rpms.famillecollet.com) as a yum repository and try again. For
other distributions, refer to
[memcached wiki](http://code.google.com/p/memcached/wiki/NewStart). The default
settings should work fine out of box; no additional configuration for memcached
would be required.

### 4. Test Auto Failover

<p class="text-center">
  <img src="/images/chrome-dev-tools-cookies.png"
    alt="Use Chrome Dev Tools to View Cookies" />
</p>

Deploy any web applications that use sessions onto both Tomcat installations.
Start Tomcat instances, Apache and memcached. Open the web address proxied by
Apache in a browser. Check the cookies set. With Chrome, this can be done with
the built-in Developer Tools, as the screenshot above shows. In my case, the
JSESSIONID value reveals that my current Tomcat instance for the session is
`jvm1`. Find out which instance is used to serve you, and shut it down. Refresh
web browser, and the cookie value should indicate that the other Tomcat instance
is taking over. Check if session values set by the application remain. For
example, if the application deployed allows user to log in, you should be able
to remain logged in after auto failover.

### Conclusion

As this post shows, memcached-session-manager is simple to configure. Together
with memcached and Apache (or any other application load balancer), it is
possible to perform round-robin deployments of web applications on Tomcat with
zero downtime. This capability allows us to achieve continuous delivery and
frequently push out new features.

### References

* [memcached-session-manager setup and
  configuration](http://code.google.com/p/memcached-session-manager/wiki/SetupAndConfiguration)
* [Tomcat 7 Clustering/Session Replication
  How-To](http://tomcat.apache.org/tomcat-7.0-doc/cluster-howto.html)
* [Apache Module mod_proxy](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html)
* [Apache Module
  mod\_proxy\_balancer](http://httpd.apache.org/docs/2.2/mod/mod_proxy_balancer.html)
