---
title: Persist PrimeFaces DataTable State Across Requests
cover_image: /images/primefaces-logo.png
date: 2012-05-14
tags: java, jsf, primefaces
---
[PrimeFaces](http://primefaces.org/) is well known for its wide array of useful
AJAX components for JSF. `<p:dataTable>`, in particular, is an extremely useful
component. One problem with `<p:dataTable>`, however, is that it can mostly only
be manipulated with AJAX. Its state, including current page, column sorted and
filter criteria, is reverted to the default after page refreshes. In addition,
there is currently no documented way to programmatically set the state, aside
from first row and sort order, for the data table.

READMORE

The solution I have come up with provides a simple way to programmatically set
the state for `<p:dataTable>`. It has the following use cases.

* Persist the state of data table across page refreshes.
* Provide a means to programmatically control the state of data table.
* The above enables a wide array of possibilities, such as controlling the state
  of data table via View/GET parameters.

However, this solution was created not by relying on the public API of
PrimeFaces, but by looking at how the component library works internally. For
example, filter parameters are passed in by setting request parameters. The
solution is therefore a bit hack-ish and may break in future PrimeFaces
releases. **The posted solution here currently works with PrimeFaces 3.4.x.** I
do not guarantee that it will work for sure with future releases, but I will try
to keep the solution updated when new versions are released. (For 3.2 & 3.3,
use [this version](https://gist.github.com/2699190/1eb63862c9c4ad63be87dbc208b026a5022c62d2)
for `PersistStateDataModel.java`.)

A sample app is available [on GitHub](https://github.com/vvasabi/com.bc.datatable).

### Step 1—Implement `PersistStateDataModel<T>`

Below is my code for `PersistStateDataModel<T>`. Current I name it so because
that is my intended use for it. Feel free to name it differently and/or create
an independent class from my code, so your existing data models do not need to
change.

<script src="https://gist.github.com/2699190.js?file=PersistStateDataModel.java"></script>

Just implement your `LazyDataModel<T>` as usual, and do the following.

* Change the parent class from `LazyDataModel<T>` to `PersistStateDataModel<T>`.
* Default state for the data table, such as default sort field, sort order and
  page size can be set in constructor.
* If you would like to persist the state across requests, make the bean’s scope
  longer than request. (This should hardly be a surprise.)
* Store the values of first, page size, sort field, sort order and filters
  passed into the `load()` method.
* Implement the abstract getters for the above values.

### Step 2—Install <code>WrapRequestFilter</code>

Because my solution requires modification to the request parameter map, the use
of a request wrapper is required. Add the following Java classes.

<script src="https://gist.github.com/2699227.js?file=WrapRequestFilter.java"></script>

<script src="https://gist.github.com/2699233.js?file=CustomRequestWrapper.java"></script>

Install the filter in web.xml like so. Change `<filter-class>` to whatever makes
sense.

<script src="https://gist.github.com/2699242.js?file=web.xml"></script>

### Step3—Modifications to xhtml

Open your xhtml page, and do the following.

* Add `binding="#{data.dataTable}"` attribute to `<p:dataTable>`. Note that
  `#{data}` is the bean you implement in Step 1.
* Place `<f:event type="preRenderComponent"
  listener="#{data.preRenderComponent}" />`. Inside `<p:dataTable>`. Once again
  change `#{data}` to whatever you use.

That’s it! Enjoy.

**Edit May 22, 2012:** The code above is broken in PrimeFaces 3.3.RC1. DataTable
appears to have a different lifecycle and does initialization at a different
rendering stage. Fix has been made, but I will release it after I have more time
to test and refine it.

**Edit May 23, 2012:** The code has been updated. This version is compatible
with both PrimeFaces 3.2 and 3.3.RC1. Note that somehow `<p:dataTable>` in
3.3.RC1 requires `lazy="true"` attribute to be set again. It needs to be added
for sorting to work.

**Edit May 29, 2012:** As expected, the same code that works for 3.3.RC1 works
for 3.3 Final.

**Edit Sep. 4, 2012:** Code that works for 3.4 has been added.

**Edit Dec. 4, 2012:** A [forum post](http://forum.primefaces.org/viewtopic.php?f=3&t=26783)
and an [issue](http://code.google.com/p/primefaces/issues/detail?id=4965) have
been created. Let’s see if PrimeFaces will create an official and cleaner way to
achieve this effect.
