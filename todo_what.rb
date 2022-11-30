# frozen_string_literal: true

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

current_path = File.dirname(__FILE__)

require "#{current_path}/parsing/meteo_xml.rb"

puts 'Music'
require "#{current_path}/parsing/pitchfork_mec.rb"

puts '', 'Film'
require "#{current_path}/parsing/cubecinema_nik.rb"
puts ''
require "#{current_path}/sundance_film/sundance_nik.rb"
