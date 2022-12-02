# frozen_string_literal: true

require 'date'
require 'time'
require 'csv'

current_path = File.dirname(__FILE__)

require "#{current_path}/lib/printer_csv.rb"
require "#{current_path}/lib/table_reader.rb"
require "#{current_path}/lib/film.rb"
require "#{current_path}/lib/film_creator.rb"

file_path = "#{current_path}/data/sundance_films.csv"

table = TableReader.new

attributes = table.prepare_hash(file_path)

array = table.filling_array(attributes)

#table.print_array(array)

puts array.sample.to_string
