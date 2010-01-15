#!/bin/ruby
require 'nokogiri'
require 'curl'


c = Curl::Easy.perform('http://espn.go.com/nfl/standings')
doc = Nokogiri::HTML(c.body_str)
s = doc.css('.oddrow', '.evenrow').collect do |x|
	wins = x.css('td')[1].content
	losses = x.css('td')[2].content
	ties = x.css('td')[3].content
	{:ties => ties.to_i, :wins => wins.to_i,  :losses => losses.to_i, :name => x.css('a')[0].content}
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
s.each {|x| puts "#{x[:wins]}\t#{x[:losses]}\t#{x[:ties]}\t#{x[:name]}"}
