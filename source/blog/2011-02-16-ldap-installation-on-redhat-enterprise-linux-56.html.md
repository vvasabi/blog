---
title: My LDAP Installation on RedHat Enterprise Linux 5.6
cover_image: /images/ldapworm.gif
date: 2011-02-16
tags: ldap, open source, red hat enterprise linux
---
Recently I have been trying to install an LDAP server, using OpenLDAP.
[Official documentation on RedHat](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Deployment_Guide/ch-ldap.html)
isn’t that straightforward. So, after spending some time both reading the
official documentation and goolging around, I'm documenting the steps I have
done here.

**Update Aug. 11, 2011:** OpenLdap on RedHat EL 6 uses a different config
format/structure. Instructions documented here does not apply.

READMORE

### 1. Installation

Installing the slapd server is quite easy:

``` bash
yum install openldap-servers
```

`yum` then takes care of the rest.

### 2. `slapd` Configuration

#### Basic Stuff

First, run `/usr/sbin/slappasswd` to generate an encrypted root password. Copy
the generated hash code, something like `{SSHA}5kl3VqG3JJNCniCyvx1vxpZ8tCctM0Ey`,
and then edit `/etc/openldap/slapd.conf`. Uncomment the line `#rootpw secret`.
Replace `secret` with the generated hash code.

Then, edit the line that goes like `suffix "dc=your-domain,dc=com"` and change
it accordingly. For my domain, I have `suffix "dc=bradchen,dc=com"`. Note that
it is a convention not to have any white space characters in this string.

Below `suffix`, the `rootdn` line also needs to be updated. For my domain, I
have `rootdn "cn=root,dc=bradchen,dc=com"`.

Save the file now.

#### Database

This step configures LDAP database backend and creates an LDAP database
configuration file. To configure the backend, open `/etc/openldap/slapd.conf`
again, and look for the line that starts with `database`. Make sure the value is
`bdb`. The end result would be a line that looks like `database bdb`.

To create an LDAP database configuration file, just run the following commands:

``` bash
cp /etc/openldap/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap /var/lib/ldap/DB_CONFIG
```

If you wish, edit /var/lib/ldap/DB_CONFIG file, and change its settings.

#### TLS

This step is optional but recommended. By default, LDAP connection is not
encrypted. For maximum security, you may wish to enable TLS support, and block
external access to port 389, that unencrypted LDAP connection runs on. First,
uncomment the following lines inside `/etc/openldap/slapd.conf`:

``` bash
# TLSCACertificateFile /etc/pki/tls/certs/ca-bundle.crt
# TLSCertificateFile /etc/pki/tls/certs/slapd.pem
# TLSCertificateKeyFile /etc/pki/tls/certs/slapd.pem
```

Save the file, and `cd` to `/etc/pki/tls/certs`.  Run the following to generate
a self-signed certificate:

``` bash
rm slapd.pem
make slapd.pem
chown ldap:ldap slapd.pem
```

If you have a certificate for the server, then just use it.

#### Start <code>slapd</code>

Now the LDAP server is ready to be started. Just run:

``` bash
/sbin/service ldap start
```

Running the LDAP server the first time may give you the following lines:

``` text
Performing database recovery to activate new settings.
bdb_db_open: Recovery skipped in read-only mode. Run manual recovery if errors are encountered.
```

This message should disappear the next time `slapd` is restarted.

### 3. Adding Entries

So far so good, eh? The steps below are where things get tricky. Documentation
for the following steps sort of scatter around the web, so I'm going to document
here what I have gathered.

#### Adding organization and organizationalRole

This step creates your organization and a root organizational role.
Documentation of this step can be found
[here](http://www.openldap.org/doc/admin24/quickstart.html). First, create a
file, called init.ldif, or whatever you wish. Use the following as the template:

```
dn: dc=example,dc=com
objectclass: dcObject
objectclass: organization
o: Example Company
dc: example

dn: cn=root,dc=example,dc=com
objectclass: organizationalRole
cn: root
```

Change the following lines, so that they reflect your setting:

```
dn: dc=example,dc=com
o: Example Company
dc: example
dn: cn=root,dc=example,dc=com
```

Run `ldapadd -x -D "cn=root,dc=example,dc=com" -W -f init.ldif` to import the
entries. Note that the `dc=example,dc=com` needs to be changed to what you have.
When prompted for credentials, just use the password you set previously with
`slappasswd`.

When using this template, if you see `additional info: objectclass: value #0
invalid per syntax`, it is likely that there are trailing spaces in the file.
The ldif format is very sensitive to white spaces. Make sure there are no
trailing white spaces.

#### Adding organizationalUnit

This step creates a user group. First, create a file called staff.ldif. Use the
following as the template:

```
dn: ou=Staff,dc=example,dc=com
objectClass: organizationalUnit
objectClass: top
ou: Staff
```

Again, run it with the `ldapadd` command, *e.g.*
`ldapadd -x -D "cn=root,dc=example,dc=com" -W -f staff.ldif`.

#### Adding a person

This step we finally start to create users. Documentation for this step can be
found [here](http://www.openldap.org/doc/admin24/access-control.html). Below is
my template:

```text
dn: uid=username,ou=Staff,dc=example,dc=com
uid: username
objectClass: person
objectClass: inetOrgPerson
cn: John Smith
gn: John
sn: Smith
mail: username@example.com
userPassword: {SSHA}hdhEo14FSPbxjNm/21APDxQ3I/+yr/VB
```

As usual, create a file, say user.ldif, and copy the template above into the
file. Edit the file, and make necessary changes. Below is a quick explanation of
what the attributes used above mean:

* uid: unique user id
* cn: common name, or the person's full name
* gn: given names
* sn: surname
* mail: e-mail address
* userPassword: user's password that can be generated using <code>/usr/sbin/slappasswd</code>.

### 4. Configure Permissions

By default, `slapd` grants no permission to users. To fix this, here are some of
the settings I use. These settings go into `/etc/openldap/slapd.conf`. After
updating this file, `slapd` needs to be restarted using `/usr/sbin/service ldap
restart`.

#### Global Read Access

This permission grants anonymous users to login, and all authenticated users to
read any entries in the directory. For example, users may lookup other users’
profiles.

```
access to *
    by users read
    by anonymous auth
```

#### Change Password

This permission lets users update their own passwords, using `ldappasswd`.

```
access to attrs=userPassword
    by self write
    by anonymous auth
```

### Conclusion

This post should cover the basics of getting an OpenLDAP server up and running.
I will come back in another post to share some common commands used to manage
LDAP entries. If CLI commands are not easy enough to use, there are several
decent-looking PHP web tools available. Although I haven’t tried out myself,
they should be pretty simple to install and use.
