---
title: MP4Box Cli Recipes
cover_image: /images/mp4box.gif
date: 2010-12-11
tags: media conversion, mp4box
---
Here are some commonly-used MP4Box commands.

READMORE

### Check MP4 File Content

``` bash
MP4Box -info <filename>
```

### Extract MP4 Track

``` bash
MP4Box -raw <Track Number> <filename>
```

Track number can be seen using `MP4Box -info`.

### Merge Raw Files into MP4

``` bash
MP4Box -add '<Video Track>#video' -add '<Audio Track>#audio' [Output Filename]
```

The `#video` and `#audio` suffixes signify the tracks are video and audio,
respectively, and should be appended to the filenames. If additional tracks need
to be added, such as subtitle tracks, just append `-add '<filename>'` to the
command before `[Output Filename]`.

Note: All the tracks in the MP4, MKV, AVI or MPEG containers need to be
extracted first before they can be put in a new MP4 container using MP4Box.