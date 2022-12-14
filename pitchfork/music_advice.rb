# frozen_string_literal: true

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'date'
require 'time'
require 'csv'

current_path = File.dirname(__FILE__)

require "#{current_path}/lib/table_reader.rb"

require "#{current_path}/lib/music.rb"
require "#{current_path}/lib/music_creator.rb"
require "#{current_path}/lib/media.rb"


file_path = "#{current_path}/data/pitchfork.csv"

table = TableReader.new

attributes = table.prepare_hash(file_path)

array = table.filling_array(attributes)

#table.print_array(array)

puts array.sample.to_string