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

[`pcase.el`][pcase-el] brought pattern matching to Emacs Lisp.
Unfortunately the documentation is a little sparse.  Hopefully this
article will go some way to helping you get a handle on pattern matching and destructuring in Emacs.

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
  (`"hello" "hello matched")
  (`"world" "world matched"))

;; => "world matched"
{% endhighlight %}

Note the **<code>`</code>** ([backquote][bq] or grave accent) is
needed as a prefix for all literal values.

{% highlight elisp %}
(setq-local num 23)

(pcase num
  (`1 "1 matched")
  (`42 "42 matched")
  (`23 "23 matched")
  (`104 "104 matched"))

;; => "23 matched"
{% endhighlight %}

If we need to match a value inside a list, we backquote the list.

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(3 4 5) "3 4 5 matched")
  (`(1 2 3) "1 2 3 matched"))

;; => "1 2 3 matched"
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

If we want to match a pattern partially we use the dontcare operator (`_` **underscore**), here's how:

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(3 4 5) "3 4 5 matched")
  (`(1 ,_ 3) "1, *anything* and 3 matched")
  (`(3 6 9) "3 6 9 matched"))

;; => "1 ? 3 matched"
{% endhighlight %}

Note that we use `,_`

In pcase patterns the comma will assign the value in place to the
symbol, let's see that...

## Capture the values

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(3 4 5) "3 4 5 matched")
  (`(1 ,_ 3) (format "1 %s 3 matched" _))
  (`(3 6 9) "3 6 9 matched"))

;; Lisp error: (void variable _)
{% endhighlight %}

Oh! Ok, well not in the case of **`,_`** because it's very special.

Ok, let's do it properly, we'll capture the second value in the list
using a symbol which we'll call **`foo`**.

In the pattern we will refer to it as **`,foo`**

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(3 4 5) "3 4 5 matched")
  (`(1 ,foo 3) (format "1, foo = %s, 3 matched" foo))
  (`(3 6 9) "3 6 9 matched"))

;; => "1, foo = 2, 3 matched"
{% endhighlight %}

By placing **`,foo`** in the pattern we capture the value in that
position and place it into our symbol `foo`.

This is how we de-structure data structures with `pcase` patterns.

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(,a ,b ,c)
   (format
    "a:%s b:%s c:%s"
    a b c)))

;; => "a:1 b:2 c:3"
{% endhighlight %}

The example above doesn't really need to be a regular `pcase`.  It's a
misuse of the `pcase` form.  Instead we should be using one of the
dedicated *pcase destructuring macros* `pcase-let` or `pcase-let*`.
We'll look at those in some more depth
later.  (If you prefer [jump to destructuring in depth right now.](#destructuring).)

## Advanced pcase patterns

Pcase has a variety of advanced patterns.

## pred

Pred, a predicate takes a function which returns a boolean (non-nil evalutes to true.)

{% highlight elisp %}
(pred {function})
{% endhighlight %}

Matches if `{function}` applied to the object returns non-nil.

Because we're in a backquote context, we comma the `(pred)` form.  The
match position will be passed to the function as a single argument.

{% highlight elisp %}
(pcase '(1 2 3)
  (`(,(pred numberp)
     ,(pred numberp)
     ,(pred numberp))
   "All numbers")
  (`(,(pred numberp)
     ,(pred numberp)
     ,(pred stringp))
   "Last is a string"))

;; => All Numbers
{% endhighlight %}

{% highlight elisp %}
(pcase '(1 2 "hello")
  (`(,(pred numberp)
     ,(pred numberp)
     ,(pred numberp))
   "All numbers")
  (`(,(pred numberp)
     ,(pred numberp)
     ,(pred stringp))
   "Last is a string"))

;; => Last is a string
{% endhighlight %}

You can use `lambda` to declare the function for a `pred` inline.

{% highlight elisp %}
(pcase '(1 2 "hello")
  (`(3 4 5) "List 3, 4, 5")
  (`(1 2
       ,(pred
         (lambda (x)
           (string-match "ell" x))))
   "A string containing 'ell'"))

;; => A string containing 'ell'
{% endhighlight %}

In the example The `lambda` will be evaluated by the `pred`, which
will pass it the match position (i.e. `"hello"`) as it's argument `x`.

{% highlight elisp %}
(pcase (string-to-number (format-time-string "%H"))
  ((pred (lambda (h) (< h 5))) "Hey it's really late!")
  ((pred (lambda (h) (< h 12))) "Good Morning")
  ((pred (lambda (h) (> h 18))) "Good Evening")
  ((pred (lambda (h) (> h 12))) "Good Afternoon"))

;; (a message for the current hour of the day)
{% endhighlight %}

## guard

{% highlight elisp %}
(guard {boolean-expression})
{% endhighlight %}

Matches if the `{boolean-expression}` evaluates to non-nil.  Unlike
`pred` no value is passed in from the current match position.

Here's a simple example:

{% highlight elisp %}
(pcase '(1 2 8)
  (`(1 2 ,(guard (= 3 1))) "Nope")
  (`(1 2 ,(guard (= 4 4))) "That is true")
  (`(1 2 ,(guard (= 1 5))) "What"))

;; That is true
{% endhighlight %}

## or

{% highlight elisp %}
(or {pattern...})
{% endhighlight %}

Matches if any of the patterns match. Let's see some examples...

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (or `(1 2 3) `(3 3 3) "matched one of these patterns"))

;; => matched one of these patterns
{% endhighlight %}

Remeber, we can use **dontcare** (`_`) in most places inside a pattern.

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (or `(3 3 3) `(1 _ 3) "matched one of these patterns"))

;; => matched one of these patterns
{% endhighlight %}

**or** can also be embedded in another pattern, for example:

{% highlight elisp %}
(setq-local numbers '(1 2 3))

(pcase numbers
  (`(1 2 ,(or 3 5))
   "list of (1 2 [3 or 5])"))

;; => list of (1 2 [3 or 5])
{% endhighlight %}

## and

{% highlight elisp %}
(and {pattern...})
{% endhighlight %}

Matches if all of the patterns match, let's look at some examples...

{% highlight elisp %}
(pcase '(1 2 3 4 5)
  (`(1 2 3
       ,(and
         (pred numberp)
         (pred (lambda (n) (> n 3))))
       ,_)
   t))

;; => t
{% endhighlight %}

{% highlight elisp %}
(pcase '(1 2 "hello")
  (`(1 2
       ,(and
         (pred stringp)
         (pred
          (lambda (s)
            (> (length s)
               4)))))
   t))

;; => t
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

[bq]: https://www.gnu.org/software/emacs/manual/html_node/elisp/Backquote.html
[john-wiegley-post]: http://newartisans.com/2016/01/pattern-matching-with-pcase/
[js-destrukt]: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
[pcase-el]: http://repo.or.cz/w/emacs.git/blob/HEAD:/lisp/emacs-lisp/pcase.el
[perl-la]: http://docstore.mik.ua/orelly/perl4/lperl/ch03_04.htm
[python-ma]: http://openbookproject.net/thinkcs/python/english3e/tuples.html#tuple-assignment
[ruby-la]: http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
[standard-ml]: https://en.wikipedia.org/wiki/Standard_ML
