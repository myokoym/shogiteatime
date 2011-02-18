#!/usr/local/bin/ruby -Ku
require 'rubygems'
require 'twitter'
require 'rss'
require 'open-uri'
require 'yaml'
require 'kconv'

rss = RSS::Parser.parse("./shogiteatime.rss")
sendlist = YAML.load_file("./sendlist.yaml")
sendlist ||= []

Twitter.configure do |config|
  config.consumer_key = "g1t2z3YgeHvFkTGxQw1xQ"
  config.consumer_secret = "T0SXDcq4WBwXuL9G9Dpmc4sKE8KLsE2ye1o69wrbcs"
  config.oauth_token = "254011888-6IL1uR7IN8a6yzYXuvNkvmQ8CtS3uGRG6ppDS2zM"
  config.oauth_token_secret = "lGHmxGv5l4xksJY6xcDf4fWWVTcGeO6n2v9JIorI"
end

def short_url(argument_url)
  argument_url
  long_url = argument_url.delete("\n").gsub("#", "%23")
  bit_request_url = "http://api.bit.ly/shorten?version=2.0.1&longUrl=#{long_url}&login=myokoym&apiKey=R_f70bcfaeb83cfc52922d5d9c53221927"
  results = YAML.load(open(bit_request_url))
  results["results"][long_url]["shortUrl"] 
end

rss.items.reverse.each do |item|
  link = item.link
  next if sendlist.include?(link)
  title = item.title
  description = item.description
  twite = [title, description].join("　")
  twite = twite[0..118] if twite.size > 119
  twite = [twite, short_url(link)].join("　").toutf8

  sendlist << link
  begin
    Twitter.update(twite)
    puts link
  rescue => e
    puts e.message
    puts twite
    next
  end
end

File.open("./sendlist.yaml", "w") {|f| f.puts YAML.dump(sendlist) }

