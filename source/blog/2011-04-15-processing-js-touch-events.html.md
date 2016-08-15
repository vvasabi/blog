---
title: Processing.js’s Touch Events
cover_image: /images/processingjs.gif
date: 2011-04-15
tags: open source, processingjs
---
With the release of Processing.js v1.1, a very interesting feature was added —
support for Webkit touch events. At the moment, there doesn't seem to be any
documentation on how these events can be used. (A [ticket for this documentation
bug](https://processing-js.lighthouseapp.com/projects/41284/tickets/1090-mouse-events-reference-is-missing-pjs-specific-funcs)
appears to exist.)

READMORE

Fortunately, using the events is simple enough — [here is a quick
demo](/demo/processing-touch/processing-touch.html). (Using this demo requires a
multi-touch device, such as an iPad.) Below is the source code of the .pde file:

<script src="https://gist.github.com/1212009.js?file=TouchEvents.pde"></script>

Essentially, the following new events were added:

* `void touchStart(TouchEvent touchEvent);`
* `void touchMove(TouchEvent touchEvent);`
* `void touchEnd(TouchEvent touchEvent);`
* `void touchCancel(TouchEvent touchEvent);`

Coordinates of the touched points can be accessed from the `touchEvent.touches`
array. `offsetX` and `offsetY` attributes of each element represent the position
relative to the canvas, and can go outside the canvas.

With this new feature, it will be possible to create many interesting stuff.
Great work Processing.js team!
