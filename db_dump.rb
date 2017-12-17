#! /usr/bin/env ruby
#
# This downloads all of the files into a directory called _posts.

require "rubygems"
require "bundler"
Bundler.require(:default)
require "json"
require "time"

ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     'localhost',
  database: 'writing'
)


class Post < ActiveRecord::Base
end
Dir.glob('_posts/*.md') do |f|
  body = File.read(f)
  prsr = FrontMatterParser::Parser.new(:md)
  fmp = prsr.call(body)
  fm = fmp.front_matter
  p fm
  dt = Time.parse(fm["datetime"])

  p = Post.find_or_create_by(id: fm["id"])
  p.title = fm["title"]
  p.content = fmp.content
  p.date = dt
  p.draft = fm["draft"]
  p.created_at ||= Time.now
  p.modified_at = Time.now
  p.save
end
