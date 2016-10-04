---
layout: page
title: About
---

This site is all about Emacs, and I hope it spurs you into learning
more for yourself.

Nothing else will enable you to build your own personal text editing
heaven, quite like Emacs.

# .emacs.d

The full config used in
the [@emacs_gifs](https://twitter.com/emacs_gifs) recordings
is [ocodo's .emacs.d](https://github.com/ocodo/.emacs.d).

# Color theme

![](https://github.com/emacsfodder/emacs-theme-darktooth/raw/master/darktooth-java.png)

The theme
is [Darktooth](https://github.com/emacsfodder/emacs-theme-darktooth),
use `M-x package-install` RETURN `darktooth-theme` to install from
Emacs.

# Modeline

The mode-line (status bar for non-Emacs people) is based
on
[Amit Patel s blog](http://amitp.blogspot.sg/2011/08/emacs-custom-mode-line.html) post
https://github.com/ocodo/.emacs.d/blob/master/custom/amitp-mode-line.el

I don't always have that switched on btw (If you're thinking, hey! that's a standard mode-line!)

# Custom keys

Custom keys are listed in [personal-keybindings](/personal-keybindings)

# Good places to feed your Emacs knowledge

The Emacs manual <kbd>Ctrl</kbd>-<kbd>h</kbd> <kbd>r</kbd> and Help
<kbd>Ctrl</kbd>-<kbd>h</kbd> along with the commands: `describe-command`,
`describe-key`, `describe-package`, `describe-function`,
`describe-variable`, etc. will really boost your understanding of
Emacs, think of it less as a text editor, and more a programming
environment which ships with a huge library of commands and
settings. (functions and variables.)

# Meta - x

There is one particular key combination that once learned will really
open up your discovery of Emacs:

<kbd>Meta</kbd>-<kbd>x</kbd>

**Did you catch that?**

Here it is again: <kbd>Meta</kbd>-<kbd>x</kbd>

> <kbd>Meta</kbd> is _usually_ the <kbd>Alt</kbd> key on modern keyboards.

**Got that?**

<kbd>Meta</kbd>-<kbd>x</kbd> is the single most useful command in Emacs.

It will start the emacs command launcher (`execute-extended-command`)
and it will make every single command in
Emacs available to you by name.

Add [`smex`](https://github.com/nonsequitur/smex) for nicer command
completion.

# Key bindings are not set in stone

If you re new to Emacs the key bindings can be overwhelming, consier
that it's important to learn how to open files
<kbd>Ctrl</kbd>-<kbd>x</kbd> <kbd>Ctrl</kbd>-<kbd>f</kbd>, save them
<kbd>Ctrl</kbd>-<kbd>x</kbd> <kbd>Ctrl</kbd>-<kbd>s</kbd> and quit
<kbd>Ctrl</kbd>-<kbd>x</kbd> <kbd>Ctrl</kbd>-<kbd>c</kbd>, I have to agree
these are not intuitive,

I added <kbd>Super</kbd>-<kbd>o</kbd> **open** <kbd>Super</kbd>-<kbd>s</kbd>
**save** and <kbd>Super</kbd>-<kbd>q</kbd> **quit** to my config to help people
coming from modern text editor apps.

> <kbd>Super</kbd> is usually <kbd>Cmd</kbd> on OS X (although <kbd>Alt</kbd> and <kbd>Cmd</kbd> are sometimes switched) and on Windows it's usually the <kbd>Windows</kbd> key.

Emacs defaults aren't pleasant for most people, and it's definitely an
editor that will require a deeper degree of learning than most, but
you will benefit enormously from the investment in time, and you'll
have a toolkit that you can use for your entire life as a programmer
or a writer.

There are many alternative keyboard command setups for Emacs, notably
Evil (which Spacemacs also gives you plus a lot of other nice packages
and configuration).

# Much more...

Visit [Awesome-Emacs](https://github.com/emacs-tw/awesome-emacs) on
github for a huge list of (all?) great Emacs things.
