---
title: git Centralized Repository Creation (for SVN users)
date: 2010-12-11
tags: git, open source, source control
---
<p class="text-center">
  <a href="/blog/2010/12/git-centralized-repository-creation"><img
    src="http://www.bradchen.com/sites/default/files/git.png"
    alt="git manual page" /></a>
</p>

Since git is a distributed source control system, having a centralized
repository is optional. People that are familiar with SVN often face the
problem—how to create a centralized repository—when they switch to git.
Fortunately, the steps are quite easy.

READMORE

### Step 1—Centralized Repository Creation

This step is like `svnadmin`, where we create a centralized repository on a possibly remote machine. To achieve the same thing with git, log onto the target machine, and use the following commands:

``` bash
mkdir /path/to/repo.git
cd /path/to/repo.git
git --bare init
```

Note that the .git extension for the folder is a convention used when creating a remote git repository.


### Step 2—Local Repository Creation

To create a local “working copy,” follow the same steps for creating a typical git repository.

``` bash
mkdir /path/to/local_working_copy
cd /path/to/local_working_copy
git init
git remote add origin ssh://username@server/path/to/repo.git
```

Note that the command `git remote add origin` connects the local working copy to
a remote repository named `origin`. To make `origin` the default remote
repository, run the following commands:

``` bash
git config branch.master.remote origin
git config branch.master.merge master
```

That's it to set things up. The next step will make the initial commit.

### Step 3—Initial Import

The first time trying to import files into a remote repository is a bit tricky,
since a new branch needs to be created. To do so, first add files to the local
repository and commit changes. Then, "push" changes to the remote repository
using:

``` bash
git push origin master:master
```

This only needs to be done the first time importing files. After that, just do
`git push`. In case you wonder, the opposite of `git push` is `git pull`, which
is equivalent to `svn update`.

### Setting User Name and E-mail

Unlike svn, committer's name and e-mail are attached to each commit. To save the
trouble of entering every time, do the following:

``` bash
git config user.name "Committer's Name"
git config user.email "committer.email@email.com"
```

If the committer's name and e-mail will always be the same for projects of the
local user, add `--global` parameter to apply it globally. For example:

``` bash
git config --global user.name "User Name"
git config --global user.email "user.email@email.com"
```

These simple steps should get you started using git with centralized repository
in no time.
