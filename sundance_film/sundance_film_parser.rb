# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'date'
require 'time'
require 'csv'

current_path = File.dirname(__FILE__)

require "#{current_path}/lib/printer_csv.rb"
require "#{current_path}/lib/parser.rb"
require "#{current_path}/lib/film.rb"
require "#{current_path}/lib/film_creator.rb"
require "#{current_path}/lib/compact.rb"

file_path = "#{current_path}/data/sundance_films.csv"

parser = Parser.new
links = parser.prepare_links

links.each do |link|
  parser.get_content(link)
end

nomination_list = parser.sundance_films

### сгруппировала номинации по фильму
##  удалила нули
#   массивы из 1 обьекта в строку и при группировке считаю количество призов
#   удаляю скобки для красивой печати в csv
using Compact
group_list = nomination_list.compact!

using DeepCompact
group_list.deep_compact!

using Brushing
film_list = group_list.brushing

using CleanBracket
list_no_brackets = group_list.clean_bracket
# нужно куда-то вынести

attributes = Film.new.hash_for_obj(list_no_brackets)

table = Printer.new

table.write_to_csv(file_path, attributes)

## Запись в CSV без скобок от [массива]
# table = table.write_to_csv(file_name, attributes )
