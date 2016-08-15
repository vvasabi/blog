---
title: OpenLDAP TLS Issue
cover_image: /images/ldapworm.gif
date: 2012-08-24
tags: ldap, nss, open source, red hat enterprise linux
---
This morning I did a `yum update` on my RHEL 6 box, and noticed the company’s
internal websites were showing up 500 error. It turned out that LDAPS
authentication was failing for those websites. Since last update was only merely
a month ago, and no configuration files were touched, it took me the entire
morning to figure out what went wrong.

READMORE

The root cause of the issue was, somehow, the TLS provider was switched to
Mozilla’s NSS along the `yum update`, and my previous configuration would fail.
Below are some of the changes I made to fix the problem.

### `/etc/openldap/slapd.d/cn=config.ldif`

``` text
olcTLSCertificateFile: /etc/pki/tls/slapd.pem
olcTLSCertificateKeyFile: /etc/pki/tls/slapd.pem
```

changed to:

``` text
olcTLSCACertificatePath: /etc/openldap/certs
olcTLSCertificateFile: "slapd"
olcTLSCertificateKeyFile: /etc/openldap/certs/password
```

The rationale of these changes is that Mozilla NSS uses the certificate database
at `/etc/openldap/certs` instead of pem files. Therefore, the next set of
commands were also necessary to create a new self-signed certificate.
(Reference: http://www.mozilla.org/projects/security/pki/nss/tools/certutil.html)

``` bash
# Create my own CA
certutil -S -s "CN=My Issuer" -n myissuer -x -t "C,C,C" -1 -2 -5  \
  -f /etc/openldap/certs/password -d /etc/openldap/certs

# Create signing request
certutil -R -s "CN=servername O=Organization, L=City, ST=State/Province, C=Country ISO2" \
  -o slapd.req -d /etc/openldap/certs

# Create certificate
certutil -C -i slapd.req -o slapd.crt -d certs -c myissuer \
  -f /etc/openldap/certs/password

# Add certificate created
certutil -A -n slapd -i slapd.crt -t "CT,," -d /etc/openldap/certs
```

Note that the certificate nickname `slapd` (specified via `-n`) needs to match
up with `olcTLSCertificateFile` in the ldif file. To verify that the certificate
was correctly created, issue this command:

``` bash
certutil -L -d /etc/openldap/certs
```

If the change was done correctly, the slapd entry should show up. Now restart
`slapd`. To verify that LDAPS is working properly, issue the command:

``` bash
openssl s_client -connect localhost:636 -showcerts
```

If everything seems normal, i.e. no error about handshake failure, then `slapd`
is now properly configured.

### `/etc/openldap/ldap.conf`

Now that the server has been configured, the client also needs to be updated.
Note the line:

```
TLS_CACERTDIR   /etc/openldap/certs
```

The path needs to point to the certificate database mentioned earlier. To test
the client, issue the following command:

``` bash
ldapsearch -d 1 -x -LLL -b cn=root -D "cn=root,dc=example,dc=com" \
  -H "ldaps://localhost:636" -W cn=config
```

Replace `cn=root,dc=example,dc=com` with your root DN and enter root DN password
when prompted. If everything is normal, there would not be any error messages
about TLS handshake. That’s it. This cost me the entire morning to figure out.

### Remote Client Setup

Now it’s time to set up remote LDAPS clients to recognize the new certificate.
To do so, run the following commands to download and import the certificate:

``` bash
openssl s_client -showcerts -connect ldaps-server:636 > ldaps-server.crt
certutil -A -n "ldaps" -t "P,P,P" -a -i ldaps-server.crt -d /etc/openldap/certs
```

Make sure `/etc/openldap/ldap.conf` also has `TLS_CACERTDIR   /etc/openldap/certs`.
These steps are good for Apache and other programs using NSS C library. For
Java, additional steps are necessary. Use the keytool to generate a jks file:

``` bash
keytool -importcert -file ldaps-server.crt -alias ldaps-server \
  -keystore ldaps-server.jks
```

The path to the jks file can be specified for a Java program by setting the
`javax.net.ssl.trustStore` property. For example, add the following command line
argument when starting the Java program:

``` bash
-Djavax.net.ssl.trustStore=/path/to/ldaps-server.jks
```

For SSH login, PAM LDAP can be enabled with:

``` bash
authconfig --enableldap --enableldapauth --disablenis --enablecache \
  --ldapserver=ldaps://ldapserver --ldapbasedn="dc=example,dc=com" \
  --updateall
```

That’s it. Hope this helps.
