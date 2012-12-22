---
title: Migrating from Drupal to Middleman
cover_image: /images/drupal-to-middleman.png
date: 2012-12-22
tags: open source, drupal, middleman, static site generator
---
The past couple of days I have bene working on migrating my
[Drupal](http://drupal.org)-powered blog to a
[Middleman](http://middlemanapp.com)-generated static website, as well as giving
my blog a facelift, a responsive layout and other goodies. So, what is wrong
with Drupal?

READMORE

### Static Site Generator Benefits

Nothing is wrong with Drupal, really. It is still a good CMS, and I still use
it for professional consulting work. For my blog, however, I think that a static
site generator like Middleman makes more sense and comes with quite a few
desirable features:

* **No more security patches to install**. Every time seeing the red warnings
  that some module needs to be patched when I sign into the admin makes me
  nervous. Long gone are the days having to constantly keeping up-to-date.
  Yes, even with Drush, it is still a pain.
* **Better integration with developer tools**. I can now write posts in vim or
  in [my favourite IDE at the moment](http://www.jetbrains.com/idea/) [0]. I can
  use git to source control my posts, not to mention I do not lose what I write
  when browser crashes. I can use Jenkins to automatically deploy when I commit.
  I don’t need to deal with less efficient web interface at all or having to
  empty cache every time I update JavaScript or stylesheets. I can also keep
  most lines adhere to the 80-character limit without worrying that some
  auto-reformat logic would work against me.
* **Built-in support for various languages**. I can use eRuby, Markdown,
  Textile, HTML, or whatever I like. Better yet, I can use SASS for CSS and
  CoffeeScript for JavaScript. Yes, Drupal supports these, but having to hunt
  down the right modules, configuring them to work properly and keeping them
  securely patched are a giant pain.
* **Site is lean, has clean markup and is easy to maintain**. Styling a CMS is
  always very time consuming. Not only does Drupal come with its own
  stylesheets that you cannot easily get rid of, but you also have to deal with
  complex auto-generated markups. Being able to write my own markups, choose the
  UI frameworks I like and organize things however I want is completely awesome.
  I can easily implement responsive design using Bootstrap, without having to
  override Drupal’s styles.

For me these are strong reasons that motivated the migration.

### Difficulties with Middleman

Middleman certainly comes with its issues. Below are the things I encountered
during the migration:

* **Lots of dependencies to install**. In order to support many languages and
  features, Middleman comes with a long list of gems that need to be installed.
  Some dependencies, like ExecJS, even require native C extensions to be built,
  which in turn require more dependencies. I had a bit of trouble trying to
  build V8 on my slightly antiquated RHEL5 box and took a while to sort out the
  trouble. There are also other cross-language dependencies, like Pygments,
  which required additional libraries to be installed. Drupal on the other hand
  usually does not require additional software to be installed in order to work.
* **Configuring Pygments was not very strightforward**. Unlike Jekyll, Middleman
  does not have a good official documentation about how one can configure
  Pygments and the GitHub-flavoured markdown. It took me a bit of Goolging,
  trial and error to get it to work the way I like.
* **Middleman blog gem feels like it has lots of room for improvement**. The
  generated template was quite lacking. For example, I would like to have a
  pagination with page numbers listed. I would like to have tags to be sorted by
  the number of posts and by alphabets. The markup could also use a bit of
  refactoring. Fortunately, static site generators are tailored towrads
  developers for a reason.
* **`middleman server` crashed a few times.** This happened mostly during making
  significant changes to eRuby layout files and introducing Ruby syntax errors.
  Since I am a Ruby beginner, I can’t really blame Middleman for this, but this
  was a challenge for me nonetheless.

### Tools Used

To build this site, I used to following gems/frameworks/libraries/platforms:

* [Middleman](http://middlemanapp.com) with
  [middleman-blog](https://github.com/middleman/middleman-blog) and
  [middleman-syntax](https://github.com/middleman/middleman-syntax).
* [Pygments](http://pygments.org) syntax highlighting through
  [redcarpet2](https://github.com/vmg/redcarpet) and
  [pygments.rb](https://github.com/tmm1/pygments.rb).
* [Sass](http://sass-lang.com) and [Compass](http://compass-style.org) for CSS
  and
  [GitHub-Flavoured Markdown](http://github.github.com/github-flavored-markdown/)
  for page content.
* [Typekit](https://typekit.com) for the
  [Myriad Pro](https://typekit.com/fonts/myriad-pro) fonts.
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/) for responsive grid
  layout and  CSS goodies.
* [Font Awesome](http://fortawesome.github.com/Font-Awesome/) for the icons.
* [IntelliJ](http://www.jetbrains.com/idea/) and [vim](http://www.vim.org) for
  building and writing everything.
* [git](http://git-scm.com) for source control and [GitHub](https://github.com)
  for hosting of source repository.
* [Jenkins](http://jenkins-ci.org) for
  [continuous delivery](http://continuousdelivery.com).

### Conclusion

I have to say using an IDE or vim to write blog posts is an absolutely pleasant
experience. I don’t have to deal with issues inherent to the web interface and
I can update my website very efficiently. Oh, and, as much as I like to use
[gist](https://gist.github.com), syntax highlighting now works wonderfully. I
don’t have to throw everything up onto gist now. I also don’t have to deal with
the trouble of having to constantly update my blog software.

Although I will still use Drupal, as clients can’t, well, use git and Markdown.
I do intend to explore the possibility to use static site generators for more
static sites, that do not require dynamic client to be entered by clients. The
challenge will be, however, the need to develop a simple workflow for designers
to be able to update a site created with a static site generator. If that can be
solved, then I will for sure see more uses of static site generators elsewhere.

With the awesome static site generator, more blog posts will keep coming.

[0]: I uninstalled four copies of Eclipse for good and freed up 2 GB of disk
     space from my SSD. More details about this story to come in a future post.
