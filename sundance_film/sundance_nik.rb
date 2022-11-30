# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'date'
require 'time'
require 'csv'

current_path = File.dirname(__FILE__)

require "#{current_path}/lib/printer.rb"
require "#{current_path}/lib/parser.rb"
require "#{current_path}/lib/film.rb"
require "#{current_path}/lib/film_creator.rb"
require "#{current_path}/lib/compact.rb"

nomination_list = Parser.new.parse_to_film

using Compact
### сгруппировала номинации по фильму
grouped_list = nomination_list.compact

# удалила нули
using DeepCompact
grouped_list.deep_compact!

# массивы из 1 обьекта в строку и при группировке считаю количество призов
using Brushing
film_list = grouped_list.brushing

attributes = Film.new.prepare_hash(film_list)

table = Printer.new

# csv_table = table.write_to_csv(attributes)

#table.print_array(attributes)

puts table.filling_array(attributes).sample.inspect


## Запись в CSV без скобок от [массива]
# attr_string = attributes.each do |film|
#   film.each do |key, str|
#     film[key] = (
#   if str.is_a? Array
#     str.join(',
# ')
#   else
#     str
#   end
# ).to_s
#   end
# end

# table = Table.new.write_to_csv(attr_string)
