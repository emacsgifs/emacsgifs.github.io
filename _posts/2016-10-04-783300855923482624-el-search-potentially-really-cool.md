---
layout: post
title: el-search is potentially really cool
thumbnail: /public/video-thumbs/783300855923482624.png
tages:
  - emacs
  - pcase
  - pattern-matching
  - elisp
  - search
  - replace
  - refactorying
  - lisp
---

[El-search](https://elpa.gnu.org/packages/el-search.html) is
potentially really cool, but needs more docs (as does pcase) it also
lacks some fairly basic user interface features. Secondary matches are
highlighted, but the actual repeat search action itself doesn't seem to be
implemented.

Search (and search/replace) history is also absent, which makes the
command quite annoying to use.

That said, I don't think it's too hard to add these feaures to
el-search, I'll definitely give it a try over the next few days.

Anyway, let's see it in action:

<video controls autoplay loop>
  <source src="/public/videos/783300855923482624.mp4" type="video/mp4">
  Sorry your browser does not support the video tag, maybe time to upgrade?
</video>

### Try these examples

{% highlight elisp %}
;; el-search --- lisp search tools

;; Search exact pattern:
;; M-x el-search-pattern `(1 1 1)

(list '(4.0 4.2 4.1) '(1 1 1) '("words" "string" "hello"))

;; Search with dontcare
;; M-x el-search-pattern `(,_ 1 ,_)

(defun dummy-func ()
  "This is a doc string."
  (list '(4.0 1 4.1)
        '(1 1 1)
        '("words" "string" "hello")))

;; M-x el-search-query-replace
;; Search for a defalias wrapping a lambda
;; `(defalias ,name (lambda ,args ,docs ,body))
;; Replace it with a defun using the same function body
;; `(defun ,name ,args ,docs ,body)

(defalias 'hello
  (lambda (a b c)
    "A B C."
    (message "%s %s %s" a b c)))

(defun 'hello
    (a b c)
  "A B C."
  (message "%s %s %s" a b c))
{% endhighlight %}
