# frozen_string_literal: true

require 'mechanize'
require 'date'
require 'json'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

agent = Mechanize.new
page = agent.get('http://pitchfork.com/reviews/albums/')

review_links = page.links_with(href: %r{^/reviews/albums/\w+})

review_links = review_links.reject do |link|
  parent_classes = link.node.parent['class'].split
  parent_classes.any? { |p| %w[next-container page-number].include?(p) }
end

review_links = review_links[0..4]

reviews = review_links.map do |link|
  review = link.click

  score = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[2]/div/div[2]/div/div/p').text.to_f
  artist = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[1]/div/ul/a/div').text
  album = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[1]/div/h1/em').text
  review_date = Time.parse(review.search('//*[@id="main-content"]/article/div[1]/header/div[3]/div/div/div/ul/li[3]/div/p[2]')[0])
  genre = review.search('//*[@id="main-content"]/article/div[1]/header/div[3]/div/div/div/ul/li[1]/div/p[2]').text

  {
    'artist' => artist,
    'album' => album,
    'genre' => genre,
    #'review_date' => review_date,
    'score' => score
  }
end

finder = proc { |k, v| reviews.select { |r| r[k].include? v } }

music_list = finder.call('genre', 'Rap')

music_advise = music_list.sample

# puts music_advise

puts reviews.sample
