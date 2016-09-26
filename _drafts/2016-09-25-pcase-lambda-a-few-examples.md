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

## What is pattern matching?

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

## The pcase macro

I'll walk you through some `pcase` examples, follow along using your Emacs
`*scratch*` buffer.

Let's start with a simple example to show the basic execution of a pcase.

{% highlight elisp %}
(setq-local hello "world")

(pcase hello
  (`"hello" (message "hello matched"))
  (`"world" (message "world matched")))

;; "world matched"
{% endhighlight %}

Note the `backquote` (or *grave accent*) is needed to match the string
literal `"world"`, (and of course try matching `"hello"`). This is
true when matching any literal value.

{% highlight elisp %}
(setq-local num 23)

(pcase num
  (`1 (message "1 matched"))
  (`42 (message "42 matched"))
  (`23 (message "23 matched"))
  (`104 (message "104 matched")))

;; "23 matched"
{% endhighlight %}

If we need to match a value inside a list, we `backquote` the list.

{% highlight elisp %}
(setq-local numbers (list 1 2 3))

(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 2 3) (message "1 2 3 matched")))

;; "1 2 3 matched"
{% endhighlight %}

## Return values

`pcase` works like any normal expression, returning the result of the evaluated s-expression.

{% highlight elisp %}
(+ 10 (pcase numbers
             (`(3 4 5)          (* 2 10))
             (`(1 2 3)          (+ 5 20)))
             ;; patterns matches |  ^ s-expressions to evaluate
;; => 25
{% endhighlight %}

## Anything goes

If we want to match a pattern partially we can use the `_` **underscore**, like this.

{% highlight elisp %}
(setq-local numbers (list 1 2 3))

(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 ,_ 3) (message "1 ? 3 matched"))
  (`(3 6 9) (message "3 6 9 matched")))

;; "1 ? 3 matched"
{% endhighlight %}

Note that we use `,_` the **comma**.  In pcase patterns the comma will
assign the value in place to the symbol, let's see that.

## Capture the values

{% highlight elisp %}
(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 ,_ 3) (message "1 %s 3 matched" _))
  (`(3 6 9) (message "3 6 9 matched")))

Lisp error: (void variable _)
{% endhighlight %}

Ok, not in the case of **underscore**, because it's special.

Let's use something else. Let's capture the second value in the list using `foo`.

{% highlight elisp %}
(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 ,foo 3) (message "1 %s 3 matched" foo))
  (`(3 6 9) (message "3 6 9 matched")))

;; "1 2 3 matched"
{% endhighlight %}

By placing `,foo` in the pattern, we capture the value in that
position and place it into the symbol `foo`.

This is the essence of the destructuring side of `pcase`.  More on that later

[js-destrukt]: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
[python-ma]: http://openbookproject.net/thinkcs/python/english3e/tuples.html#tuple-assignment
[ruby-la]: http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
[standard-ml]: https://en.wikipedia.org/wiki/Standard_ML
[john-wiegley-post]: http://newartisans.com/2016/01/pattern-matching-with-pcase/
