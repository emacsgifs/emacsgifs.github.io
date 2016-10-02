---
layout: post
title: HTML entities helper
---

While I was building my [custom keys](/personal-keybindings) page I
needed HTML entities to replace characters I need that blow up markdown.

This is something I just built incidentally and maybe I should turn
this into a package. For now I thought I'd just post the code, because
it gives me a chance to share how it works and how I built it.

The entity list I used is
from
[Wikipedia][entities-page]. so
I figured it'd be interesting to talk a little bit about how I scraped it.

Jumping into the Chrome Dev Tools console, I used some jQuery and
JS/ES6, to grab the useful text from the table of entities.

[On the page][entities-page], there's a single `table.wikitable.sortable`. This
contains the useful HTML entity info.

I used the following code to scrape out the interesting parts. (reformatted from a one-liner.)

{% highlight js %}
$('table.wikitable.sortable tr').
  map(function(i, e) {
    // Use destructuring to grab the contents
    // of indices 0, 1 and 6 from each chil array of
    // the tr elements found (i.e. the td elements).
    [ent,chr,,,,,dsc] = e.children.map(function(i, e) {
      return e.innerText;
    });
    return `char: ${chr} entity: &${ent}; text: ${dsc}`;
  }).
  toArray().
  join("\n");
{% endhighlight %}

The output looks like this:

{% highlight text %}
char: ¢ entity: &cent; text: cent sign
char: £ entity: &pound; text: pound sign
char: ¤ entity: &curren; text: currency sign
char: ¥ entity: &yen; text: yen sign (yuan sign)
{% endhighlight %}

While I could use one of many scripting options to do this scraping, I
find that using the Dev Tools to do an initial scrape and figure out
CSS selector paths, is the most interactive and so easy and efficient.

If I'm going to scrape the same page many times, and I expect more
dynamic content, I'd definitely migrate out to something else. (What
that is would depend on a lot of factors.)

Anyway, I have my list, so paste it into Emacs and let's do a little
tidying up. (I could've done most od this up front BTW.)

After trimming off the enclosing quotes, I converted each line into a
lisp string. From the top of the buffer: `C-M-%` regexp: `.*` with: `"\&"` (then `!` replace all)

Afterwards the entries look like this:

{% highlight text %}
"char: ¢ entity: &cent; text: cent sign"
"char: £ entity: &pound; text: pound sign"
"char: ¤ entity: &curren; text: currency sign"
"char: ¥ entity: &yen; text: yen sign (yuan sign)"
{% endhighlight %}

I think It's nice to align the **text:** entries. I select all the
entries and do `M-x align-regexp` with: "` text: `", and we get this result:

{% highlight text %}
"char: ¢ entity: &cent;   text: cent sign"
"char: £ entity: &pound;  text: pound sign"
"char: ¤ entity: &curren; text: currency sign"
"char: ¥ entity: &yen;    text: yen sign (yuan sign)"
{% endhighlight %}

Next wrap the whole thing in `defvar` as a list:

<div class="overflow-long">
{% highlight elisp %}
(defvar html-entity-list
  '("char: \" entity: &quot;    text: quotation mark (APL quote)"
    "char: & entity: &amp;      text: ampersand"
    "char: ' entity: &apos;     text: apostrophe (apostrophe-quote); see below"
    "char: < entity: &lt;       text: less-than sign"
    "char: > entity: &gt;       text: greater-than sign"
    "char:   entity: &nbsp;     text: no-break space (non-breaking space)[d]"
    "char: ¡ entity: &iexcl;    text: inverted exclamation mark"
    "char: ¢ entity: &cent;     text: cent sign"
    "char: £ entity: &pound;    text: pound sign"
    "char: ¤ entity: &curren;   text: currency sign"
    "char: ¥ entity: &yen;      text: yen sign (yuan sign)"
    "char: ¦ entity: &brvbar;   text: broken bar (broken vertical bar)"
    "char: § entity: &sect;     text: section sign"
    "char: | entity: &#124;     text: vertical bar (unix pipe)"
    "char: ¨ entity: &uml;      text: diaeresis (spacing diaeresis); see Germanic umlaut"
    "char: © entity: &copy;     text: copyright symbol"
    "char: ª entity: &ordf;     text: feminine ordinal indicator"
    "char: « entity: &laquo;    text: left-pointing double angle quotation mark (left pointing guillemet)"
    "char: ¬ entity: &not;      text: not sign"
    "char:   entity: &shy;      text: soft hyphen (discretionary hyphen)"
    "char: ® entity: &reg;      text: registered sign (registered trademark symbol)"
    "char: ¯ entity: &macr;     text: macron (spacing macron, overline, APL overbar)"
    "char: ° entity: &deg;      text: degree symbol"
    "char: ± entity: &plusmn;   text: plus-minus sign (plus-or-minus sign)"
    "char: ² entity: &sup2;     text: superscript two (superscript digit two, squared)"
    "char: ³ entity: &sup3;     text: superscript three (superscript digit three, cubed)"
    "char: ´ entity: &acute;    text: acute accent (spacing acute)"
    "char: µ entity: &micro;    text: micro sign"
    "char: ¶ entity: &para;     text: pilcrow sign (paragraph sign)"
    "char: · entity: &middot;   text: middle dot (Georgian comma, Greek middle dot)"
    "char: ¸ entity: &cedil;    text: cedilla (spacing cedilla)"
    "char: ¹ entity: &sup1;     text: superscript one (superscript digit one)"
    "char: º entity: &ordm;     text: masculine ordinal indicator"
    "char: » entity: &raquo;    text: right-pointing double angle quotation mark (right pointing guillemet)"
    "char: ¼ entity: &frac14;   text: vulgar fraction one quarter (fraction one quarter)"
    "char: ½ entity: &frac12;   text: vulgar fraction one half (fraction one half)"
    "char: ¾ entity: &frac34;   text: vulgar fraction three quarters (fraction three quarters)"
    "char: ¿ entity: &iquest;   text: inverted question mark (turned question mark)"
    "char: ` entity: &#96;      text: grave accent"
    "char: À entity: &Agrave;   text: Latin capital letter A with grave accent (Latin capital letter A grave)"
    "char: Á entity: &Aacute;   text: Latin capital letter A with acute accent"
    "char: Â entity: &Acirc;    text: Latin capital letter A with circumflex"
    "char: Ã entity: &Atilde;   text: Latin capital letter A with tilde"
    "char: Ä entity: &Auml;     text: Latin capital letter A with diaeresis"
    "char: Å entity: &Aring;    text: Latin capital letter A with ring above (Latin capital letter A ring)"
    "char: Æ entity: &AElig;    text: Latin capital letter AE (Latin capital ligature AE)"
    "char: Ç entity: &Ccedil;   text: Latin capital letter C with cedilla"
    "char: È entity: &Egrave;   text: Latin capital letter E with grave accent"
    "char: É entity: &Eacute;   text: Latin capital letter E with acute accent"
    "char: Ê entity: &Ecirc;    text: Latin capital letter E with circumflex"
    "char: Ë entity: &Euml;     text: Latin capital letter E with diaeresis"
    "char: Ì entity: &Igrave;   text: Latin capital letter I with grave accent"
    "char: Í entity: &Iacute;   text: Latin capital letter I with acute accent"
    "char: Î entity: &Icirc;    text: Latin capital letter I with circumflex"
    "char: Ï entity: &Iuml;     text: Latin capital letter I with diaeresis"
    "char: Ð entity: &ETH;      text: Latin capital letter Eth"
    "char: Ñ entity: &Ntilde;   text: Latin capital letter N with tilde"
    "char: Ò entity: &Ograve;   text: Latin capital letter O with grave accent"
    "char: Ó entity: &Oacute;   text: Latin capital letter O with acute accent"
    "char: Ô entity: &Ocirc;    text: Latin capital letter O with circumflex"
    "char: Õ entity: &Otilde;   text: Latin capital letter O with tilde"
    "char: Ö entity: &Ouml;     text: Latin capital letter O with diaeresis"
    "char: × entity: &times;    text: multiplication sign"
    "char: Ø entity: &Oslash;   text: Latin capital letter O with stroke (Latin capital letter O slash)"
    "char: Ù entity: &Ugrave;   text: Latin capital letter U with grave accent"
    "char: Ú entity: &Uacute;   text: Latin capital letter U with acute accent"
    "char: Û entity: &Ucirc;    text: Latin capital letter U with circumflex"
    "char: Ü entity: &Uuml;     text: Latin capital letter U with diaeresis"
    "char: Ý entity: &Yacute;   text: Latin capital letter Y with acute accent"
    "char: Þ entity: &THORN;    text: Latin capital letter THORN"
    "char: ß entity: &szlig;    text: Latin small letter sharp s (ess-zed); see German Eszett"
    "char: à entity: &agrave;   text: Latin small letter a with grave accent"
    "char: á entity: &aacute;   text: Latin small letter a with acute accent"
    "char: â entity: &acirc;    text: Latin small letter a with circumflex"
    "char: ã entity: &atilde;   text: Latin small letter a with tilde"
    "char: ä entity: &auml;     text: Latin small letter a with diaeresis"
    "char: å entity: &aring;    text: Latin small letter a with ring above"
    "char: æ entity: &aelig;    text: Latin small letter ae (Latin small ligature ae)"
    "char: ç entity: &ccedil;   text: Latin small letter c with cedilla"
    "char: è entity: &egrave;   text: Latin small letter e with grave accent"
    "char: é entity: &eacute;   text: Latin small letter e with acute accent"
    "char: ê entity: &ecirc;    text: Latin small letter e with circumflex"
    "char: ë entity: &euml;     text: Latin small letter e with diaeresis"
    "char: ì entity: &igrave;   text: Latin small letter i with grave accent"
    "char: í entity: &iacute;   text: Latin small letter i with acute accent"
    "char: î entity: &icirc;    text: Latin small letter i with circumflex"
    "char: ï entity: &iuml;     text: Latin small letter i with diaeresis"
    "char: ð entity: &eth;      text: Latin small letter eth"
    "char: ñ entity: &ntilde;   text: Latin small letter n with tilde"
    "char: ò entity: &ograve;   text: Latin small letter o with grave accent"
    "char: ó entity: &oacute;   text: Latin small letter o with acute accent"
    "char: ô entity: &ocirc;    text: Latin small letter o with circumflex"
    "char: õ entity: &otilde;   text: Latin small letter o with tilde"
    "char: ö entity: &ouml;     text: Latin small letter o with diaeresis"
    "char: ÷ entity: &divide;   text: division sign (obelus)"
    "char: ø entity: &oslash;   text: Latin small letter o with stroke (Latin small letter o slash)"
    "char: ù entity: &ugrave;   text: Latin small letter u with grave accent"
    "char: ú entity: &uacute;   text: Latin small letter u with acute accent"
    "char: û entity: &ucirc;    text: Latin small letter u with circumflex"
    "char: ü entity: &uuml;     text: Latin small letter u with diaeresis"
    "char: ý entity: &yacute;   text: Latin small letter y with acute accent"
    "char: þ entity: &thorn;    text: Latin small letter thorn"
    "char: ÿ entity: &yuml;     text: Latin small letter y with diaeresis"
    "char: Œ entity: &OElig;    text: Latin capital ligature oe[e]"
    "char: œ entity: &oelig;    text: Latin small ligature oe[e]"
    "char: Š entity: &Scaron;   text: Latin capital letter s with caron"
    "char: š entity: &scaron;   text: Latin small letter s with caron"
    "char: Ÿ entity: &Yuml;     text: Latin capital letter y with diaeresis"
    "char: ƒ entity: &fnof;     text: Latin small letter f with hook (function, florin)"
    "char: ˆ entity: &circ;     text: modifier letter circumflex accent"
    "char: ˜ entity: &tilde;    text: small tilde"
    "char: Α entity: &Alpha;    text: Greek capital letter Alpha"
    "char: Β entity: &Beta;     text: Greek capital letter Beta"
    "char: Γ entity: &Gamma;    text: Greek capital letter Gamma"
    "char: Δ entity: &Delta;    text: Greek capital letter Delta"
    "char: Ε entity: &Epsilon;  text: Greek capital letter Epsilon"
    "char: Ζ entity: &Zeta;     text: Greek capital letter Zeta"
    "char: Η entity: &Eta;      text: Greek capital letter Eta"
    "char: Θ entity: &Theta;    text: Greek capital letter Theta"
    "char: Ι entity: &Iota;     text: Greek capital letter Iota"
    "char: Κ entity: &Kappa;    text: Greek capital letter Kappa"
    "char: Λ entity: &Lambda;   text: Greek capital letter Lambda"
    "char: Μ entity: &Mu;       text: Greek capital letter Mu"
    "char: Ν entity: &Nu;       text: Greek capital letter Nu"
    "char: Ξ entity: &Xi;       text: Greek capital letter Xi"
    "char: Ο entity: &Omicron;  text: Greek capital letter Omicron"
    "char: Π entity: &Pi;       text: Greek capital letter Pi"
    "char: Ρ entity: &Rho;      text: Greek capital letter Rho"
    "char: Σ entity: &Sigma;    text: Greek capital letter Sigma"
    "char: Τ entity: &Tau;      text: Greek capital letter Tau"
    "char: Υ entity: &Upsilon;  text: Greek capital letter Upsilon"
    "char: Φ entity: &Phi;      text: Greek capital letter Phi"
    "char: Χ entity: &Chi;      text: Greek capital letter Chi"
    "char: Ψ entity: &Psi;      text: Greek capital letter Psi"
    "char: Ω entity: &Omega;    text: Greek capital letter Omega"
    "char: α entity: &alpha;    text: Greek small letter alpha"
    "char: β entity: &beta;     text: Greek small letter beta"
    "char: γ entity: &gamma;    text: Greek small letter gamma"
    "char: δ entity: &delta;    text: Greek small letter delta"
    "char: ε entity: &epsilon;  text: Greek small letter epsilon"
    "char: ζ entity: &zeta;     text: Greek small letter zeta"
    "char: η entity: &eta;      text: Greek small letter eta"
    "char: θ entity: &theta;    text: Greek small letter theta"
    "char: ι entity: &iota;     text: Greek small letter iota"
    "char: κ entity: &kappa;    text: Greek small letter kappa"
    "char: λ entity: &lambda;   text: Greek small letter lambda"
    "char: μ entity: &mu;       text: Greek small letter mu"
    "char: ν entity: &nu;       text: Greek small letter nu"
    "char: ξ entity: &xi;       text: Greek small letter xi"
    "char: ο entity: &omicron;  text: Greek small letter omicron"
    "char: π entity: &pi;       text: Greek small letter pi"
    "char: ρ entity: &rho;      text: Greek small letter rho"
    "char: ς entity: &sigmaf;   text: Greek small letter final sigma"
    "char: σ entity: &sigma;    text: Greek small letter sigma"
    "char: τ entity: &tau;      text: Greek small letter tau"
    "char: υ entity: &upsilon;  text: Greek small letter upsilon"
    "char: φ entity: &phi;      text: Greek small letter phi"
    "char: χ entity: &chi;      text: Greek small letter chi"
    "char: ψ entity: &psi;      text: Greek small letter psi"
    "char: ω entity: &omega;    text: Greek small letter omega"
    "char: ϑ entity: &thetasym; text: Greek theta symbol"
    "char: ϒ entity: &upsih;    text: Greek Upsilon with hook symbol"
    "char: ϖ entity: &piv;      text: Greek pi symbol"
    "char:   entity: &ensp;     text: en space[d]"
    "char:   entity: &emsp;     text: em space[d]"
    "char:   entity: &thinsp;   text: thin space[d]"
    "char:   entity: &zwnj;     text: zero-width non-joiner"
    "char:   entity: &zwj;      text: zero-width joiner"
    "char:   entity: &lrm;      text: left-to-right mark"
    "char:   entity: &rlm;      text: right-to-left mark"
    "char: – entity: &ndash;    text: en dash"
    "char: — entity: &mdash;    text: em dash"
    "char: ‘ entity: &lsquo;    text: left single quotation mark"
    "char: ’ entity: &rsquo;    text: right single quotation mark"
    "char: ‚ entity: &sbquo;    text: single low-9 quotation mark"
    "char: “ entity: &ldquo;    text: left double quotation mark"
    "char: ” entity: &rdquo;    text: right double quotation mark"
    "char: „ entity: &bdquo;    text: double low-9 quotation mark"
    "char: † entity: &dagger;   text: dagger, obelisk"
    "char: ‡ entity: &Dagger;   text: double dagger, double obelisk"
    "char: • entity: &bull;     text: bullet (black small circle)[f]"
    "char: … entity: &hellip;   text: horizontal ellipsis (three dot leader)"
    "char: ‰ entity: &permil;   text: per mille sign"
    "char: ′ entity: &prime;    text: prime (minutes, feet)"
    "char: ″ entity: &Prime;    text: double prime (seconds, inches)"
    "char: ‹ entity: &lsaquo;   text: single left-pointing angle quotation mark[g]"
    "char: › entity: &rsaquo;   text: single right-pointing angle quotation mark[g]"
    "char: ‾ entity: &oline;    text: overline (spacing overscore)"
    "char: ⁄ entity: &frasl;    text: fraction slash (solidus)"
    "char: € entity: &euro;     text: euro sign"
    "char: ℑ entity: &image;    text: black-letter capital I (imaginary part)"
    "char: ℘ entity: &weierp;   text: script capital P (power set, Weierstrass p)"
    "char: ℜ entity: &real;     text: black-letter capital R (real part symbol)"
    "char: ™ entity: &trade;    text: trademark symbol"
    "char: ℵ entity: &alefsym;  text: alef symbol (first transfinite cardinal)[h]"
    "char: ← entity: &larr;     text: leftwards arrow"
    "char: ↑ entity: &uarr;     text: upwards arrow"
    "char: → entity: &rarr;     text: rightwards arrow"
    "char: ↓ entity: &darr;     text: downwards arrow"
    "char: ↔ entity: &harr;     text: left right arrow"
    "char: ↵ entity: &crarr;    text: downwards arrow with corner leftwards (carriage return)"
    "char: ⇐ entity: &lArr;     text: leftwards double arrow[i]"
    "char: ⇑ entity: &uArr;     text: upwards double arrow"
    "char: ⇒ entity: &rArr;     text: rightwards double arrow[j]"
    "char: ⇓ entity: &dArr;     text: downwards double arrow"
    "char: ⇔ entity: &hArr;     text: left right double arrow"
    "char: ∀ entity: &forall;   text: for all"
    "char: ∂ entity: &part;     text: partial differential"
    "char: ∃ entity: &exist;    text: there exists"
    "char: ∅ entity: &empty;    text: empty set (null set); see also U+8960, ⌀"
    "char: ∇ entity: &nabla;    text: del or nabla (vector differential operator)"
    "char: ∈ entity: &isin;     text: element of"
    "char: ∉ entity: &notin;    text: not an element of"
    "char: ∋ entity: &ni;       text: contains as member"
    "char: ∏ entity: &prod;     text: n-ary product (product sign)[k]"
    "char: ∑ entity: &sum;      text: n-ary summation[l]"
    "char: − entity: &minus;    text: minus sign"
    "char: ∗ entity: &lowast;   text: asterisk operator"
    "char: √ entity: &radic;    text: square root (radical sign)"
    "char: ∝ entity: &prop;     text: proportional to"
    "char: ∞ entity: &infin;    text: infinity"
    "char: ∠ entity: &ang;      text: angle"
    "char: ∧ entity: &and;      text: logical and (wedge)"
    "char: ∨ entity: &or;       text: logical or (vee)"
    "char: ∩ entity: &cap;      text: intersection (cap)"
    "char: ∪ entity: &cup;      text: union (cup)"
    "char: ∫ entity: &int;      text: integral"
    "char: ∴ entity: &there4;   text: therefore sign"
    "char: ∼ entity: &sim;      text: tilde operator (varies with, similar to)[m]"
    "char: ≅ entity: &cong;     text: congruent to"
    "char: ≈ entity: &asymp;    text: almost equal to (asymptotic to)"
    "char: ≠ entity: &ne;       text: not equal to"
    "char: ≡ entity: &equiv;    text: identical to; sometimes used for 'equivalent to'"
    "char: ≤ entity: &le;       text: less-than or equal to"
    "char: ≥ entity: &ge;       text: greater-than or equal to"
    "char: ⊂ entity: &sub;      text: subset of"
    "char: ⊃ entity: &sup;      text: superset of[n]"
    "char: ⊄ entity: &nsub;     text: not a subset of"
    "char: ⊆ entity: &sube;     text: subset of or equal to"
    "char: ⊇ entity: &supe;     text: superset of or equal to"
    "char: ⊕ entity: &oplus;    text: circled plus (direct sum)"
    "char: ⊗ entity: &otimes;   text: circled times (vector product)"
    "char: ⊥ entity: &perp;     text: up tack (orthogonal to, perpendicular)[o]"
    "char: ⋅ entity: &sdot;     text: dot operator[p]"
    "char: ⌈ entity: &lceil;    text: left ceiling (APL upstile)"
    "char: ⌉ entity: &rceil;    text: right ceiling"
    "char: ⌊ entity: &lfloor;   text: left floor (APL downstile)"
    "char: ⌋ entity: &rfloor;   text: right floor"
    "char: 〈 entity: &lang;    text: left-pointing angle bracket (bra)[q]"
    "char: 〉 entity: &rang;    text: right-pointing angle bracket (ket)[r]"
    "char: ◊ entity: &loz;      text: lozenge"
    "char: ♠ entity: &spades;   text: black spade suit[f]"
    "char: ♣ entity: &clubs;    text: black club suit (shamrock)[f]"
    "char: ♥ entity: &hearts;   text: black heart suit (valentine)[f]"
    "char: ♦ entity: &diams;    text: black diamond suit[f]")
  "List of HTML entities with helpful text notes.

Scraped from Wikipedia at https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references")
{% endhighlight %}
</div>

I realised that a few things I needed most were missing, the grave
accent (i.e. backtick) `&#96;` &#96; and the vertical bar `&#124;`
(&#124; pipe.)

These two have named entities, but they aren't widely supported so
it's best to use the numeric style enitities.

Since they were missuing I added them into the list manually. Now,
even though these were the entities that I really wanted for my
current use case, I've often wanted to have a list of HTML entities
available instantly.

I'd usually not need to find one very often so I'd jump into a browser
and pull up a match from google, to grab a specific entity.  This is
the sort of trigger that will lead me to add things to Emacs.  I'll do
something often, and there's a reasonable way to do it, but it'll be
nowhere near as fast as it could be done in Emacs.

Anyway, back to the code, using `completing-read` we can select a row
from the list with completion:

{% highlight elisp %}
(defun html-entity-select ()
  "Select an html entry from the list."
  (interactive)
  (completing-read "HTML Entity: " html-entity-list))
{% endhighlight %}

With `completing-read` we can select from the list and get Emacs built in
completion.

This is ok, but the great thing about `completing-read` is it's
overriden by some neat selection frameworks. Ido (`ido-everywhere` and
`ido-ubiquitous` in particular) and Ivy (`ivy-completing-read`) both
do (or allow) this approach. Since I use **ido** I get this selection
style: (BTW I'm also using [`ido-vertical`](https://github.com/creichert/ido-vertical-mode.el))

![](/images/select-entities-1.png)

With [`flx-ido`](https://github.com/lewang/flx/blob/master/flx-ido.el) I also get fuzzy matching:

![](/images/select-entities-2.png)

**Note**: Helm is also a good candidate selection framework, but it
needs specialized functions written for it.

Finally let's tie everything together into a command we can bind to the keyboard:

{% highlight elisp %}
(require 's)

(defun html-entity-insert ()
  "Select and insert an html entity."
  (interactive)
  (let*  ((entry (html-entity-select))
          ;; use a regexp to extract the HTML entity.
          (entity (second (s-match "entity: \\(&.*?;\\)" entry))))
    (insert entity)))
{% endhighlight %}

We take the selected list entry and pull the entity string out of it.
I use [**s.el**](https://github.com/magnars/s.el) for convenience.
Then just use `(insert ...)` to enter it into our buffer.

I hope this was relatively simple to follow along,  If you
have any questions, tweet a message to [@emacs_gifs](https://twitter.com/emacs_gifs).

[entities-page]: https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Character_entity_references_in_HTML
