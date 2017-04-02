#! /usr/bin/env ruby

# This downloads all of the files into a directory called posts.

require "open-uri"
require "json"
require "front_matter_parser"
require "time"

CRLF_REGEX = /\r\n?/

open("https://writing.natwelch.com/posts.md.json") do |res|

  queue = Queue.new
  urls = JSON.parse(res.read)
  urls.map { |url| queue << url }

  threads = 10.times.map do
    Thread.new do
      while !queue.empty? && u = queue.pop
        open("https://writing.natwelch.com#{u.sub(".", "/")}") do |r|
          body = r.read.gsub(CRLF_REGEX, "\n")
          fmp = FrontMatterParser.parse(body)
          fm = fmp.front_matter
          p fm
          dt = Time.parse(fm["datetime"])
          filename = File.join "_posts/", "#{dt.strftime "%Y-%m-%d"}-#{File.basename(u)}"
          File.open(filename, 'w') do |f|
            f.write(body)
          end
        end
      end
    end
  end

  threads.each(&:join)
end
