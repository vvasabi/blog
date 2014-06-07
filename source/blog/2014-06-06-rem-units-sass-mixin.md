---
title: Sass Mixin for Setting Font Sizes in Rem Units
cover_image: /images/logo-sass.png
date: 2014-06-06
tags: sass
---
Here is a Sass mixin that makes setting font sizes in 
[rem units](http://css-tricks.com/theres-more-to-the-css-rem-unit-than-font-sizing/) easy. As a
bonus, it also provides backward compatibility for IE 8 and below that do not support rem units.

READMORE

<script src="https://gist.github.com/vvasabi/324f8e1b522536eb95d5.js"></script>

The third `font-weight` argument is optional. If you wish, you could make `line-height` optional,
too, but I always like to set `font-size` together with `line-height`.

Enjoy.
