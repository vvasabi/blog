---
title: Middleman
cover_image: /images/middleman.png
date: 2016-08-15
tags: open source, middleman, static site generator
---
Hello world! This is my first post since 2014, and hopefully I will start blogging more again. For
this post, I would like to talk about Middleman, a static site generator, that I have been using
during the past 3.5 years. READMORE I use Middleman for _all_ my projects that require HTML,
JavaScript and CSS. Here are the kinds of projects that I have used Middleman for:

* This blog
* Small and simple static websites
* Single page apps (SPAs) for browsers or for the WebView of a desktop or mobile app
* A large, bilingual info website with several hundreds of pages for a major Canadian telecom
* Microsites deployed onto a Canadian bank’s enterprise CMS

While each type of the projects above may be configured differently and may use different
extensions, they all use Middleman in the core. As I use Middleman heavily, I have built extensions
(some open source, some closed source) for Middleman, as well as a GUI launcher (unfortunately,
_not yet_ open sourced).

My frontend projects lately all use the following frameworks/tools and I enjoy great productivity:

* AngularJS 1
* BabelJS
* Lodash
* Sass (compiled using SassC/LibSass)
* Bourbon
* Middleman 3 or 4


### Pros of Middleman

* **Flexibility**: Middleman can be configured to work for any projects that require HTML,
  JavaScript and CSS to be generated. It supports many languages, such as Markdown or Sass and can
  be configured to support more. The recent introduction of
  [external pipeline](https://middlemanapp.com/advanced/external-pipeline/) makes Middleman even
  more flexible by allowing other compilers or asset processors to be hooked into Middleman.
* **Integrated with SCM**: By using an SCM, such as Git, you gain a powerful version control
  facility for your content. Not a lot of CMSes provide the power, flexibility, speed and
  reliability of a proper SCM for tracking revision history of content.
* **Use of Ruby Language**: This is both a pro and a con. Middleman is written in Ruby and makes use
  of Ruby libraries/gems. For rubyists, this language provides an elegant and expressive syntax. It
  also allows a programmer to tap into a wealthy breadth of gems and a vibrant community of Ruby
  developers.
* **Static Output**: Similar to any other static site generators, Middleman produces static assets
  that do not change. This means it is very easy to deploy a site built using Middleman, and there
  are much fewer server-related issues, such as security vulnerabilities, performance or caching, to
  worry about.


### Cons of Middleman

* **Use of Ruby Language**: For non-rubyists, the Ruby language can require a small learning curve.
  Although very little Ruby knowledge is required to successfully use Middleman, it does impose the
  programming language upon users. For example, the config file uses Ruby syntax, and the layout
  file, by default, is in eRuby. In addition, in today’s world of frontend developers, who gravitate
  towards frameworks and toolchains built on top of [NodeJS](https://nodejs.org/en/), the Ruby
  community forms a small league of its own. Nonetheless, Middleman allows and officially recommends
  tools from NodeJS to be hooked into Middleman via the external pipeline feature.
* **Lack of GUI for Non-Coders**: When a non-coder needs to be able to update the content of a site,
  then the use of Middleman (or any static site generator that does not have a pretty GUI) can be
  out of question. Fortunately, this is rarely a concern for me, since projects I work on are
  maintained by developers most of the time. Still, to make the life of coders easier, I have built
  a simple GUI tool that removes the need to manually type commands and provides an easy way to
  restart Middleman quickly, among other bells and whistles. (Once again, I have not open sourced
  this tool yet but likely will.)


### Conclusion

If you are looking for a static site generator or haven’t used one before, I sincerely suggest that
you give Middleman a try.
