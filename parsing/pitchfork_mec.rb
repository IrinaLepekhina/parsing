# frozen_string_literal: true

require 'mechanize'
require 'date'
require 'json'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

agent = Mechanize.new

links = []
list_reviews = []

(1..2).each do |n|
  link = "https://pitchfork.com/reviews/albums/?page=#{n}"
  links.push(link)
end

puts links.inspect

links.each do |link|
  page = agent.get(link)

  review_links = page.links_with(href: %r{^/reviews/albums/\w+})

  review_links = review_links.reject do |link|
    parent_classes = link.node.parent['class'].split
    parent_classes.any? { |p| %w[next-container page-number].include?(p) }
  end

  reviews = review_links.map do |l|
    review = l.click

    score = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[2]/div/div[2]/div/div/p').text.to_f
    artist = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[1]/div/ul/a/div').text
    album = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[1]/div/h1/em').text
    # review_date = Time.parse(review.search('//*[@id="main-content"]/article/div[1]/header/div[3]/div/div/div/ul/li[3]/div/p[2]')[0]).strftime('%d.%m.%y')
    genre = review.search('//*[@id="main-content"]/article/div[1]/header/div[3]/div/div/div/ul/li[1]/div/p[2]').text
    link = l.to_s

    {
      'artist' => artist,
      'album' => album,
      'genre' => genre,
      'score' => score,
      'link' => link
      # 'review_date' => review_date
    }
  end
  list_reviews.push(reviews)
end

puts list_reviews.inspect
# def write_to_csv(data)
headers = %w[artist album genre review_date score link]
file_name = 'pitchfork.csv'

table = CSV.generate do |csv|
  csv << headers
  list_reviews.each do |p|
    p.each do |album|
      csv << album.values
    end
  end
end
File.write(file_name, table, mode: 'a')

puts "Ваша запись сохранена в файл #{file_name}"
# end

# finder = proc { |k, v| list_reviews.select { |r| r[k].include? v } }

# music_list = finder.call('genre', 'Rap')

# music_advise = music_list.sample

# puts music_advise

# puts list_reviews
