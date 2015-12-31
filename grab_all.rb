#! /usr/bin/env ruby

# This downloads all of the files into a directory called posts.

require "open-uri"
require "json"

open("https://writing.natwelch.com/posts.md.json") do |res|
  p res
  data = JSON.parse(res.read)
  p data
end
