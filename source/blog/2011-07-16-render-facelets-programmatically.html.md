---
title: Render Facelets Programmatically
cover_image: /images/jsf-logo.png
date: 2011-07-16
tags: jsf, open source
---
Recently I have been trying to build the ability to send e-mails in a JSF project. Since Facelets is a great templating technology, I want to render the e-mails with Facelets. To my surprise, this isn't an easy thing to do.

READMORE

I started by following the solution [documented
here](http://www.ninthavenue.com.au/blog/how-to-create-email-from-jsf-pages).
On my Apache MyFaces 2.1.1 setup, the result was empty — nothing would be
rendered. After spending a few hours poking around the source code of MyFaces,
it revealed that `ViewDeclarationLanguage.buildView()` needed to be called
first. The content would now be rendered. This made me happy for about 30
minutes.

After 30 minutes, there was a second challenge. For whatever reason, calling
`renderView()` screws up MyFaces’ response to AJAX calls. Not being able to send
out e-mails when the action is triggered by an AJAX call would be a great
annoyance.

In order to fix the problem, I needed to find a replacement for the
`renderView()` call. It turned out that Seam framework’s solution was to
traverse and render the components manually, instead of calling `renderView()`
directly. It worked great!

So, my final code for rendering Facelets looks like this:

<script src="https://gist.github.com/1087206.js?file=FaceletRenderer.java"></script>

A bonus of this solution is that there is no need to capture the output via a
fake response object. Since the output gets written to ResponseWriter when the
components are encoded, building a ResponseWriter with a StringWriter would
allow the result to be extracted.

This solution has been tested to work on MyFaces 2.1.1 and Mojarra 2.1.2.

**Update Aug. 11, 2011:** a usage example is available [here](https://github.com/vvasabi/Programmatic-Facelets-Rendering-Example).
