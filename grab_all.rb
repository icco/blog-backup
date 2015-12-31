#! /usr/bin/env ruby

# This downloads all of the files into a directory called posts.

require "open-uri"
require "json"

open("https://writing.natwelch.com/posts.md.json") do |res|
  data = JSON.parse(res.read)
  data.each do |u|
    filename = "posts/#{File.basename(u)}"
    File.open(filename, 'w') do |f|
      doc = URI("https://writing.natwelch.com#{u.sub(".", "/")}").read
      f.write(doc)
    end
  end
end
