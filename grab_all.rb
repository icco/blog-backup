#! /usr/bin/env ruby

# This downloads all of the files into a directory called posts.

require "open-uri"
require "json"

open("https://writing.natwelch.com/posts.md.json") do |res|

  queue = Queue.new
  urls = JSON.parse(res.read)
  urls.map { |url| queue << url }

  threads = 10.times.map do
    Thread.new do
      while !queue.empty? && u = queue.pop
        filename = "posts/#{File.basename(u)}"
        open("https://writing.natwelch.com#{u.sub(".", "/")}") do |r|
          File.open(filename, 'w') do |f|
            f.write(r.read)
          end
        end
      end
    end
  end

  threads.each(&:join)
end
