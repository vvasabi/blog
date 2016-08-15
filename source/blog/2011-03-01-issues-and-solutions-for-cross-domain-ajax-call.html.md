---
title: Issues and Solutions for Cross-Domain Ajax Calls
cover_image: /images/jquery-and-rest.png
date: 2011-03-01
tags: java, javascript, open source
---
Recently I have been building a small chat room application, using
[jQuery](http://jquery.org/) for Ajax and
[RESTEasy](http://www.jboss.org/resteasy) for server-side RESTful services.
Because Java is used for the server side, and PHP is used to render the
JavaScript for the client side, I need to use cross-domain Ajax calls. Like
Flash, Ajax imposes security restrictions for such remote invocations. Here, I’m
documenting the problems and solutions I have.

READMORE

### 1. Access Control Http Headers

The first problem is that browsers require the access control headers to be set,
in order for a cross-domain Ajax call to succeed. This problem is quite simpl
 to solve. From the server side, just add the following headers to the response:

* `Access-Control-Allow-Origin`
* `Access-Control-Allow-Methods`
* `Access-Control-Allow-Headers`

For my app to work, I have the following settings:

* `Access-Control-Allow-Origin: *`
* `Access-Control-Allow-Methods: OPTIONS, GET, POST, PUT, DELETE`
* `Access-Control-Allow-Headers: Content-Type, X-Requested-With`

Note that the allowed origin is set to a wildcard. For server-sdie services in
production, it may be a good idea to specify the domains that are allowed to
access. The complete discussion on access control headers
[can be found here](https://developer.mozilla.org/En/HTTP_access_control).

### 2. Maintaining Sessions

It appears that JavaScript does not set, nor pass along cookies for cross-domain
Ajax calls. This is not a big problem, because data can be passed along as
parameters or inside the message bodies anyways. What is more of a problem is
that sessions often rely on cookies to achieve. Without the support for cookies,
each request is a new session. Without sessions, the state needs to be
maintained by the client, and more data would need to be passed along in each
request.

Fortunately, Java allows session ids to be specified in the request urls. For
example, `http://www.example.org/;jsessionid=abcde12345`. One may write an
`appendSession()` function to append session ids to the urls of Ajax calls.
(The actual GET parameter is container-specific and may not be `jsessionid`.)

Also, the second requirement for this solution is to create the ability for the
JavaScript client to acquire the session id. Since JavaScript cannot access the
`Set-Cookie` header, that session ids are often specified in, the JavaScript
client needs to be able to get the session id elsewhere. My solution is,
therefore, to expose the current session id in one of the RESTful services.
However, since I'm not a security expert, I'm not sure if there would be any
security concerns around this practice. I will update this post if I find any.

### Conclusion

It seems that, unlike Flash, making cross-domain Ajax calls is easy enough.
Thumbs up for open technology.
