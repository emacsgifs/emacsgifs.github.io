---
layout: post
title: iedit-mode (the basics)
tags:
  - iedit
  - replace
  - multiple-cursors
  - editing
  - convenience
---

**iedit-mode** (aka interactive-edit-mode) gives you the power to edit
instances of the same text string in a buffer.  It's quite similar to
multiple cursors, although if you're used to working with multiple
cursors, it's likely you'll prefer that.

IEdit defaults to selecting all matches, and then allows you to reduce
and expand the matches in various ways, so the workflow is in the
opposite direction.

I use **iedit** often as a quick interactive _replace all_,
and multiple cursors for anything in between that and more complicated
regexp search replace.

In conjunction with `wgrep-mode` (that is a writeable grep mode, which
works with most grep alternative tools as well) `iedit-mode` can
become a poweful way to edit a string across many files and review the
changes before you save them.

To install it use `M-x package-install iedit`

Once installed you can start it with `C-;` (`M-x iedit-mode`)

Note, this doesn't work in a terminal so in that case I'd bind it to `C-c ;`

Spacemacs has a binding for IEdit mode on it's SPACE leader `(SPC s e)`

<video controls autoplay>
  <source src="/public/videos/757220492944171009.mp4" type="video/mp4">
    Sorry your browser does not support the video tag, maybe time to upgrade?
</video>
