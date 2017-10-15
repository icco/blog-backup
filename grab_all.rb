#! /usr/bin/env ruby
#
# This downloads all of the files into a directory called _posts.

require "rubygems"
require "bundler"
Bundler.require(:default)
require "open-uri"
require "json"
require "time"

CRLF_REGEX = /\r\n?/

open("https://natwelch-writing.appspot.com/posts.md.json") do |res|

  queue = Queue.new
  urls = JSON.parse(res.read)
  urls.map { |url| queue << url }

  threads = 10.times.map do
    Thread.new do
      while !queue.empty? && u = queue.pop
        open("https://natwelch-writing.appspot.com#{u.sub(".", "/")}") do |r|
          begin
            body = r.read.gsub(CRLF_REGEX, "\n")
            prsr = FrontMatterParser::Parser.new(:md)
            fmp = prsr.call(body)
            fm = fmp.front_matter
            p fm
            dt = Time.parse(fm["datetime"])
            filename = File.join "_posts/", "#{dt.strftime "%Y-%m-%d"}-#{File.basename(u)}"
            File.open(filename, "w") do |f|
              f.write(body)
            end
          rescue Exception => e
            p u
            puts e.message
            puts e.backtrace.inspect
          end
        end
      end
    end
  end

  threads.each(&:join)
end
