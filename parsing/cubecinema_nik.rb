# frozen_string_literal: true

require 'open-uri'
require 'nokogiri' # Vs xpath
require 'date'
require 'time'
# require "uri"

html = URI.parse('https://cubecinema.com/programme/').open(&:read)

doc = Nokogiri::HTML(html)

showings = []
doc.css('.showing').each do |showing|
  title_el = showing.at_css('h3')
  title_el.children.each { |c| c.remove if c.name == 'span' }
  title = title_el.text.strip

  showing_id = showing['id'].split('_').last.to_i

  tags = showing.css('.tags a').map { |tag| tag.text.strip }

  description = showing.at_css('.copy').text.gsub('[more...]', '').strip

  date_raw = showing.at_css('.start_and_pricing').text.strip.split

  date_string = case date_raw[2]
                when 'November'
                  "#{date_raw[1]}-#{date_raw[2]}-2022, #{date_raw[4]}"
                when 'December'
                  "#{date_raw[1]}-#{date_raw[2]}-2022, #{date_raw[4]}"
                else
                  "#{date_raw[1]}-#{date_raw[2]}-2023, #{date_raw[4]}"
                end

  date = Time.parse(date_string)

  torrent_search = 'https://rutracker.org/forum/tracker.php?nm=' + title.gsub(' ', '%20').gsub('\'','%27')
  youtube_search = 'https://www.youtube.com/results?search_query=' + title.gsub(' ', '+').gsub('\'','%27')

  showings.push({
                  'id' => showing_id,
                  'title' => title,
                  'tags' => tags,
                  #'dates' => date,
                  'description' => description,
                  'torrent_search' => torrent_search,
                  'youtube_search' => youtube_search
                })
end

# require 'json'
# puts events = JSON.pretty_generate(showings)

finder = proc { |k, v| showings.select { |r| r[k].include? v } }

film_list = finder.call('tags', 'film')

cinema_advise = film_list.sample

puts cinema_advise
