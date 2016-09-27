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
documentation is a little sparse.  Hopefully this article will go some
way to helping you get a handle on `pcase` and it's associated macros.

## What is pattern matching?

The majority of software developers will be aware of some pattern
matching features, even if not by the same name.

Since 2015 JavaScript has [destructuring assignment][js-destrukt]
built in, and it's so ridiculously useful that it's unlikely to slip
past most active JS developers.

Common scripting languages will have some similar
features. [Perl has list assignment][perl-la]. [Ruby too, inspired by Perl][ruby-la],
[Python has something a little better, tuple assignment/unpacking][python-ma].

Functional (and functional hybrid languages) usually have some form of
pattern matching. It's a language fearture that originates
from [Standard ML][standard-ml].

Pattern matching includes destructuring, but also provides conditions.
You can perform branching based on a data-structure matching one of a
set of patterns.

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

Note the **<code>`</code>** ([backquote][bq] or grave accent) is
needed as a prefix for all literal values.

```
hello
```

{% highlight elisp %}
(setq-local num 23)

(pcase num
  (`1   (message "1 matched"))
  (`42  (message "42 matched"))
  (`23  (message "23 matched"))
  (`104 (message "104 matched")))

;; "23 matched"
{% endhighlight %}

If we need to match a value inside a list, we backquote the list.

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 2 3) (message "1 2 3 matched")))

;; "1 2 3 matched"
{% endhighlight %}

## Return values

`pcase` works like any normal expression, returning the result of the evaluated form.

{% highlight elisp %}
(+ 10 (pcase numbers
              ( `(3 4 5)   (* 2 10))
              ( `(1 2 3)   (+ 5 20)))
           ;; ^ patterns | ^ evaluate
;; => 25
{% endhighlight %}

## Anything goes

If we want to match a pattern partially we can use the don't care operator (`_` **underscore**), like this.

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(3 4 5)  (message "3 4 5 matched"))
  (`(1 ,_ 3) (message "1, *anything* and 3 matched"))
  (`(3 6 9)  (message "3 6 9 matched")))

;; "1 ? 3 matched"
{% endhighlight %}

Note that we use `,_`

In pcase patterns the comma will assign the value in place to the
symbol, let's see that...

## Capture the values

{% highlight elisp %}
(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 ,_ 3) (message "1 %s 3 matched" _))
  (`(3 6 9) (message "3 6 9 matched")))

Lisp error: (void variable _)
{% endhighlight %}

Oh! Ok, well not in the case of **`,_`** because it's very special.

Ok, let's do it properly, we'll capture the second value in the list
using a symbol which we'll call **`foo`**.

In the pattern we will refer to it as **`,foo`**

{% highlight elisp %}
(pcase numbers
  (`(3 4 5) (message "3 4 5 matched"))
  (`(1 ,foo 3) (message "1, foo = %s, 3 matched" foo))
  (`(3 6 9) (message "3 6 9 matched")))

;; "1, foo = 2, 3 matched"
{% endhighlight %}

By placing **`,foo`** in the pattern we capture the value in that
position and place it into our symbol `foo`.

This is how we de-structure data structures with `pcase` patterns.

{% highlight elisp %}
(pcase numbers
  (`(,a ,b ,c) (message "a:%s b:%s c:%s" a b c)))

;; "a:1 b:2 c:3"
{% endhighlight %}

The example above doesn't really need to be a regular `pcase`.  It's a
misuse of the `pcase` form.  Instead we should be using one of the
dedicated *pcase destructuring macros* `pcase-let` or `pcase-let*`.
We'll look at those in some more depth
later.  (If you prefer [jump to destructuring in depth right now.](#destructuring).)

## Advanced pcase patterns

Pcase has a variety of advanced patterns, le's look into them now...

## pred

{% highlight elisp %}
(pred {function})
{% endhighlight %}

Matches if `{function}` applied to the object returns non-nil.

## guard

{% highlight elisp %}
(guard {boolean-expression})
{% endhighlight %}

Matches if the `{boolean-expression}` evaluates to non-nil.

Here's a few examples:

## or

{% highlight elisp %}
(or {pattern...})
{% endhighlight %}

Matches if any of the patterns match. Let's see some examples...

{% highlight elisp %}
(pcase numbers
  (or `(1 2 3) `(3 3 3) (message "matched one of these patterns")))

;; matched one of these patterns
{% endhighlight %}

The _don't care operator_ will work in an `or` case, note that in the `or` form we use **`_`**
instead of **`,_`**

{% highlight elisp %}
(pcase numbers
  (or `(3 3 3) `(1 _ 3) "matched one of these patterns"))

;; matched one of these patterns
{% endhighlight %}

**or** can also be embedded in another pattern, for example:

{% highlight elisp %}
(pcase numbers
  (`(1 2 ,(or 3 5)) "list of (1 2 [3 or 5])"))

;; list of (1 2 [3 or 5])
{% endhighlight %}

## and

{% highlight elisp %}
(and {pattern...})
{% endhighlight %}

Matches if all of the patterns match, let's look at some examples...

{% highlight elisp %}
(pcase '(1 2 "hello")
  (`(1 2
       ,(and (pred stringp)
             (pred (lambda (s) (> (length s) 4)))))
   "This matched"))

;; This matched
{% endhighlight %}

## let

{% highlight elisp %}
(let {pattern} {expression})
{% endhighlight %}

Matches if `{expression}` matches `{pattern}`

Here's a few examples:

## app

{% highlight elisp %}
(app {function} {pattern})
{% endhighlight %}

Matches if `{function}` applied to the object matches `{pattern}`.

Here's a few examples:

<a name="destructuring"/>
## Destructuring in depth

As we saw earlier, We can capture specific values from a
data-structure using `pcase` patterns, there are two dedicated macros
that we can use for destructuring `pcase-let` and `pcase-let*`.

While it's possible to do simple destructuring with the `pcase` macro, it's cleaner to use the `pcase-let` forms. For example:

{% highlight elisp %}
(setq-local time-list
            (mapcar
             'string-to-int
             (s-split ":" (format-time-string "%H:%M:%S"))))

(pcase-let  ((`(,hour ,min ,second) time-list))
  (pcase hour
    (pred (lambda (h) (< 12 h)) "it's Morning")
    (pred (lambda (h) (> 18 h)) "it's Evening")
    (pred (lambda (h) (> 12 h)) "it's Afternoon")))
{% endhighlight %}


[js-destrukt]: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
[python-ma]: http://openbookproject.net/thinkcs/python/english3e/tuples.html#tuple-assignment
[perl-la]: http://docstore.mik.ua/orelly/perl4/lperl/ch03_04.htm
[ruby-la]: http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
[standard-ml]: https://en.wikipedia.org/wiki/Standard_ML
[john-wiegley-post]: http://newartisans.com/2016/01/pattern-matching-with-pcase/
[bq]: https://www.gnu.org/software/emacs/manual/html_node/elisp/Backquote.html
