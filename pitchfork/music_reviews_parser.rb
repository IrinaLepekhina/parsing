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
require 'csv'

current_path = File.dirname(__FILE__)

require "#{current_path}/lib/parser.rb"
require "#{current_path}/lib/printer_csv.rb"
require "#{current_path}/lib/table_reader.rb"

require "#{current_path}/lib/music.rb"
require "#{current_path}/lib/music_creator.rb"
require "#{current_path}/lib/media.rb"

file_path = "#{current_path}/data/pitchfork.csv"

parser = Parser.new
load_list = 15..25
links = parser.prepare_links(load_list)

links.each do |link|
  parser.get_content(link)
end

## закомментировала вставку заголовков
table = Printer.new
table.write_to_csv(file_path, parser.pitchfork_reviews)