---
layout: post
title: Delimit-columns let's change some settings
legacy_url: https://emacsgifs.github.io/tweets/761168479009419264.html
thumbnail: /public/video-thumbs/761168479009419264.png
tags:
  - columns
  - align
  - delimit-columns
  - emacs
---

Change some delimit-columns settings to quote wrap our values.

You can use `delimit-columns-customize` to set the values, or set these variables directly.

{% highlight elisp %}
(setq delimit-columns-str-separator ", ")
(setq delimit-columns-str-before "{ ")
(setq delimit-columns-str-after " }")
(setq delimit-columns-separator ", ")
(setq delimit-columns-before "\"")
(setq delimit-columns-after "\"")
{% endhighlight %}

<video controls autoplay loop>
  <source src="/public/videos/761168479009419264.mp4" type="video/mp4">
    Sorry your browser does not support the video tag, maybe time to upgrade?
</video>
