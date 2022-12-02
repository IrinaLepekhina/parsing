# frozen_string_literal: true

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'mechanize'
require 'date'
require 'json'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

current_path = File.dirname(__FILE__)

require "#{current_path}/lib/parser.rb"
require "#{current_path}/lib/printer.rb"
require "#{current_path}/lib/media.rb"
require "#{current_path}/lib/music.rb"
require "#{current_path}/lib/music_creator.rb"


## в парсере закомментила строку с заголовками, чтобы они не вставлялисьа только дописывались новые

## сейчас при вызове только фильтрует таблицу локальнуюю 
## парсинг закоменчен

file_path = "#{current_path}/data/pitchfork.csv"

# parser = Parser.new
# load_list = 1..2
# links = parser.pitch.prepare_links(load_list)

# links.each do |link|
#   parser.get_content(link)
# end

# table = Printer.new
# table.write_to_csv(file_path, parser.pitchfork_reviews)

table = Printer.new

attributes = table.prepare_hash(file_path)

puts table.filling_array(attributes).sample.inspect


## не используюб не адаптировано

  # finder = proc { |k| table.select { |r| r[k].include? v } }

  # music_list = finder.call('genre', 'Rap')

  # music_advise = music_list.sample

  # puts music_list
