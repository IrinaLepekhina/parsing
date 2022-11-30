# frozen_string_literal: true

require 'open-uri'
require 'nokogiri' # Vs xpath
require 'date'
require 'time'

html = URI.parse('https://www.rollingstone.com/music/music-lists/best-hip-hop-albums-1323916/juice-wrld-goodbye-and-good-riddance-2018-1354866/').open(&:read)

doc = Nokogiri::HTML(html)
albums = []

puts doc.css('#pmc-gallery-vertical > div.c-gallery-vertical > div > div:nth-child(2) > article > h2').children[0].text

# pmc-gallery-vertical > div.c-gallery-vertical > div > div:nth-child(1) > article > h2

# c-gallery-vertical__slides

# section.each do |album|

#   puts album.css("h2").text

# end

puts 'Done'
# puts albums

# number = ""
# description = ""

# albums.push({
#             'title' => title,
#             'number' => number,
#             'description' => description
#           })
