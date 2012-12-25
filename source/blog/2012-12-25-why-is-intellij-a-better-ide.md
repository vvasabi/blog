---
title: Why is IntelliJ Idea a better IDE?
cover_image: /images/eclipse-to-intellij-idea.png
date: 2012-12-25
tags: java, intellij
---
It seems that it is a widely held opinion that
[IntelliJ Idea](http://www.jetbrains.com/idea/) is a better IDE
than [Eclipse](http://www.eclipse.org). As an Eclipse user for several years, I
thought I would give IntelliJ Idea a shot when version 12 came out. After 2
weeks into using it, I wasted no time in grabbing myself a license when
JetBrains offered
[Doomsday Sale](http://blog.jetbrains.com/blog/2012/12/20/jetbrains-end-of-the-world-clearance-sale-24-hours-only/). So, what’s so good about IntelliJ Idea?

READMORE

### Strengths over Eclipse

Here I will try to document things I really like about IntelliJ Idea, as well as
my rants against Eclipse.

#### Integrated Experience for Various Languages

I cannot emphasize enough how good IntelliJ truly makes IDE feels like an
_integrated_ experience. Developers nowadays no longer work with just a single
programming language like years ago. Instead, web developers like myself have
to learn a wide array of different programming and domain specific languages.

Yes, Eclipse does support many languages. In fact, it probably supports more
than IntelliJ does. The problem is that, for each specific language, Eclipse has
an edition for that, and many of them were not created by Eclipse Foundation.
This results in inconsistencies, incompatibilities and differences in the speed
to upgrade the core.

One specific example of the issue that I ran into was trying to install [Aptana
Studio](http://www.aptana.com). on top of
[Spring Tool Suite (STS)](http://www.springsource.org/sts), when I needed to use
both Ruby and Java for a [project](https://github.com/vvasabi/sassy-faces) that
I was working on. Both of these IDEs are popular and solid editions of Eclipse.
Installing together, however, one can observe many inconsistencies. Aptana
Studio comes with its own syntax colouring system, whereas STS uses Eclipse’s
built-in engine. Since I used
[Eclipse Color Theme](http://eclipsecolorthemes.org) plugin, having to configure
Aptana Studio separately to have the colours match as much as possible was quite
an annoyance.

Then, I had to configure editor association for overlapping file types that both
IDEs tried to support. Notable ones are web-related source files, such as HTML,
XML, CSS and JavaScript. There came more configurations that I had to do.

Some editions also lagged behind for supporting new Eclipse core. [Scala IDE for
Eclipse](http://scala-ide.org) and [PHP Development
Tools](http://www.eclipse.org/projects/project.php?id=tools.pdt) were examples
where I ran into issue installing them on top of the latest Eclipse core
release. I had to download and install the bundled version in order to use them.

Although these were mostly annoyances and not factors that would stop me from
using Eclipse, I did end up having 4 installations of Eclipse on my machine.
Also, every time I had to install a different edition of Eclipse, I had to take
the time and install all the plugins I used. This was quite counter-productive.

### Things both Sides Do Well

### Weaknesses over Eclipse

The only thing that I find myself missing from Eclipise is just the fact that
AspectJ support in IntelliJ Idea is rather outdated. The `declare parents`
syntax, for example, has a
[ticket](http://youtrack.jetbrains.com/issue/IDEA-59138) opened since September,
2010 but has not received any love from JetBrains. This causes some
Roo-generated ITDs not to be properly parsed by IntelliJ and auto completions
for certain classes to fail. I had no choice but to push in these ITD
declarations in order to work around it.

### Conclusion

So, after two weeks of using IntelliJ, I have to say that I absolutely love it.
Though, to be fair, there are not too many things that IntelliJ can do that
Eclipse (through its various editions and plugins) cannot. IntelliJ does enable
me to work more efficiently because I do not have to switch between different
versions of Eclipse, maintain preference settings when switching or creating
new workspaces, fight against Eclipse indentation quirks. I can also code faster
with better auto completion and code generation support. In the end, I happily
uninstalled my 4 installations of Eclipse and freed up 2 GB of precious space
from my SSD.


