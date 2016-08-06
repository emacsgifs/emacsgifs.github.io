#!/usr/bin/env ruby

tweet_id=ENV['tweet_id']
body=ENV['body']

puts %Q[<tr><td class="emacs-gif-archive-entry">
  <a href="/tweets/#{tweet_id}.html"> #{body}</a>
</td></tr>]
