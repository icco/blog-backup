#! /usr/bin/env ruby
#
# This downloads all of the files into a directory called _posts.

require "rubygems"
require "bundler"
Bundler.require(:default)
require "open-uri"
require "json"
require "time"
require "graphql/client"
require "graphql/client/http"

CRLF_REGEX = /\r\n?/

http = GraphQL::Client::HTTP.new("https://graphql.natwelch.com/graphql") do
  def headers(context)
    { "User-Agent": "blog-backup" }
  end
end
schema = GraphQL::Client.load_schema(http)
client = GraphQL::Client.new(schema: schema, execute: http)
Query = client.parse <<-'GRAPHQL'
  query {
    posts(limit: 1000, offset: 0) {
      id
      title
      content
      datetime
      draft
    }
  }
GRAPHQL

res = client.query(Query)
res.data.posts.each do |post|
  dt = Time.parse(post.datetime)
  filename = File.join "_posts/", "#{dt.strftime "%Y-%m-%d"}-#{post.id}.md"
  p filename

  body = <<-HEAD
---

id: #{post.id}
datetime: "#{dt}"
title: "#{post.title}"
draft: #{post.draft}
permalink: "/post/#{post.id}"

---

#{post.content}
HEAD

  # Validate yaml
  prsr = FrontMatterParser::Parser.new(:md)
  fmp = prsr.call(body)
  fm = fmp.front_matter
  p fm

  # Write that shit
  File.open(filename, "w") do |f|
    f.write(body)
  end
end
