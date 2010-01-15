#!/bin/ruby
require 'nokogiri'
require 'curl'

c = Curl::Easy.perform('http://espn.go.com/college-football/standings')
doc = Nokogiri::HTML(c.body_str)
s = doc.css('.oddrow', '.evenrow').collect do |x|
	record = x.css('td')[2]
	if record
		match = record.content.match(/(\d*)-(\d*)/)
		wins = match[1]
		losses = match[2]
		{:wins => wins.to_i,  :losses => losses.to_i, :name => x.css('a')[0].content}
	end
end
s = s.select {|x| x }
s.sort! do |x,y| 
	i = y[:wins] <=> x[:wins] 
	if i == 0
		x[:losses] <=> y[:losses]
	else
		i
	end
end
s.each {|x| puts "#{x[:wins]}\t#{x[:losses]}\t#{x[:name]}"}
