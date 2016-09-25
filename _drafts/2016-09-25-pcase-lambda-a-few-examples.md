---
layout: post
title: Pcase Lambda - a few examples
tags:
  - emacs
  - pcase
  - pattern-matching
  - no-tweet
  - code
  - emacs-lisp
---

The
[`pcase.el`](http://repo.or.cz/w/emacs.git/blob/HEAD:/lisp/emacs-lisp/pcase.el) package
brings pattern matching to Emacs Lisp.  Unfortunately the
documentation is a little sparse, so I'm posting a few articles to dig
deeper into `pcase`.

### What is pattern matching?

The majority of software developers will be aware of some pattern
matching features, even if not by the same name.

Since 2015 JavaScript has [destructuring assignment][js-destrukt]
built in, and it's so ridiculously useful that it's unlikely to slip
past most active JS developers.

Common scripting languages will have some similar
features. [Perl has list assignment][perl-la]. [Ruby has something similar, inspired by Perl][ruby-la],
[Python has tuple assignment/unpacking][python-ma].

Functional (and functional hybrid languages) usually have some form
of pattern matching, as it originates from [Standard ML][standard-ml].

Pattern matching is similar to plain old destructuring, with the
addition of conditional behaviour.  You can match a given pattern
against a given data structure.

# The pcase macro

Let's look at some simple ways that pattern matching can be used for
conditional destructuring.

Note: This example is expanded
from [John Wiegley's post][john-wiegley-post] (I encourage you to read
the whole post, and try out the examples.)

We'll be working with `value` defined as

{% highlight elisp %}
'(1 2 (4 . 5) "Hello")
{% endhighlight %}

A simple enough data structure. Let's make it available for us to play with.

Switch to your `*scratch*` buffer `C-x b` paste in this s-expression:

{% highlight elisp %}
(setq-local value  '(1 2 (4 . 5) "Hello"))
{% endhighlight %}

Evaluate this expression with `C-x C-e`, now we can do things with
`value`.

Let's check it with the `equal` function. `equal` will check that
two data structures have the same values.

{% highlight elisp %}
(equal
  value
  '(1 2 (4 . 5) "Hello"))

;; => t
{% endhighlight %}

Let's say we want to check that the final value is a string, it's
quite a bit of code.

{% highlight elisp %}
(and
  (equal
    (subseq value 0 3)
    '(1 2 (4 . 5)))
  (stringp (nth 3 value)))

;; => t
{% endhighlight %}

Using `pcase` patterns we can really slim this down.

{% highlight elisp %}
(pcase value
  (`(1 2 (4 . 5) ,(pred stringp))
  (message "value matched")))
{% endhighlight %}

This `pcase` form works like a switch/case,
The `pred` form is useful for


[js-destrukt]: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
[python-ma]: http://openbookproject.net/thinkcs/python/english3e/tuples.html#tuple-assignment
[ruby-la]: http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
[standard-ml]: https://en.wikipedia.org/wiki/Standard_ML
[john-wiegley-post]: http://newartisans.com/2016/01/pattern-matching-with-pcase/
