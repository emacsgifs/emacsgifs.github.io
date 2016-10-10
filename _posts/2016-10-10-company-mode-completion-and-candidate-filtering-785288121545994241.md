---
layout: post
title: Company mode completion in Spacemacs
thumbnail: /public/video-thumbs/785288121545994241.png
tages:
  - emacs
  - spacemacs
  - auto-completion
  - company-mode
  -
---

While I don't use the Spacemacs emacs config, it's silly to say there
aren't some cool things in there.  Especially if you're thinking about
switching from Vim to Emacs.

Auto-completion isn't on by default, but you can get it up and running
fairly easily.

In your `.spacemacs` config, you add the layer:

{% highlight elisp %}
auto-completion
{% endhighlight %}

To turn it on.  You'll also need to add this to your `dotspacemacs/user-config`:

{% highlight elisp %}
(global-company-mode t)
{% endhighlight %}

<video controls autoplay>
  <source src="/public/videos/785288121545994241.mp4" type="video/mp4">
  Sorry your browser does not support the video tag, maybe time to upgrade?
</video>

In the video you'll see there are a couple of handy key bindings set
to filter the completion candidates.

- <kbd>Ctrl</kbd>-<kbd>/</kbd> - Search/Filter candidates (using Helm)

- <kbd>Meta</kbd>-<kbd>Ctrl</kbd>-<kbd>/</kbd> - Search/Filter
  candidates in place.



For the second filter, the search string you enter is displayed in the
middle of in the mode-line.

I must admit, I didn't see it to begin with. It's fairly surprising to
see text entry in the mode-line.

Thanks go out to Evan N-D/@futuro and @Cassiel-Girl on
https://gitter.im/syl20bnr/spacemacs for helping me find out about
these filter options.
