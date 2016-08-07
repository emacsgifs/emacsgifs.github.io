#!/usr/bin/env ruby

tweet_id=ENV['tweet_id']
body=ENV['body']

puts %Q^
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="Emacs GIFS">
    <link rel="stylesheet" type="text/css" media="screen" href="/stylesheets/stylesheet.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Emacs GIFS</title>
  </head>
  <body>
    <!-- HEADER -->
    <div id="header_wrap_bg" class="outer">
      <div id="header_wrap" class="outer">
        <header class="inner">
          <a id="forkme_banner" href="https://github.com/emacsgifs/emacsgifs">View on GitHub</a>
          <h1 id="project_title"><a href="/">Emacs GIFS</a></h1>
          <p style="font-size: 14pt" id="project_tagline">Bite-sized snippets of Emacs in action. <a href="https://twitter.com/emacs_gifs">(on Twitter since 2016)</a></p>
        </header>
      </div>
      <div>
        <!-- MAIN CONTENT -->
        <div id="main_content_wrap" class="outer">
          <section id="main_content" class="inner">
            <p>#{body}</p>
            <video controls autoplay>
            <source src="#{tweet_id}.mp4" type="video/mp4">
            Sorry your browser does not support the video tag, maybe time to upgrade?
            </video>
            <hr/>
            <div id="disqus_thread">
            </div>
            <script>
              (function() {
              var d = document, s = d.createElement('script');
              s.src = '//emacsgifs.disqus.com/embed.js';
              s.setAttribute('data-timestamp', +new Date());
              (d.head || d.body).appendChild(s);
              })();
            </script>
            <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
          </section>
        </div>
        <!-- FOOTER  -->
        <div id="footer_wrap" class="outer">
          <footer class="inner">
            <p class="copyright">Emacs GIFS maintained by <a href="https://github.com/jasonm23">Jasonm23</a></p>
            <p>Published with <a href="https://pages.github.com">GitHub Pages</a></p>
          </footer>
        </div>
      </div>
    </div>
    <script id="dsq-count-scr" src="//emacsgifs.disqus.com/count.js" async></script>
  </body>
</html>
^