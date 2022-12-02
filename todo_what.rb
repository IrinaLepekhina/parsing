# frozen_string_literal: true

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

current_path = File.dirname(__FILE__)

require "#{current_path}/meteo_xml.rb"

puts 'Music'
require "#{current_path}/pitchfork/music_advice.rb"

puts '', 'Film'
require "#{current_path}/cubecinema_nik.rb"
puts ''
require "#{current_path}/sundance_film/film_advice.rb"
