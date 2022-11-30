# frozen_string_literal: true

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'net/http'
require 'uri'
require 'rexml/document'
require 'cgi'

CITIES        = { Voronezh: 'https://xml.meteoservice.ru/export/gismeteo/point/148.xml',
                  Perm: 'https://xml.meteoservice.ru/export/gismeteo/point/59.xml',
                  Guadalahara: 'https://xml.meteoservice.ru/export/gismeteo/point/10139.xml' }.freeze
CLOUDINESS    = { -1 => 'туман', 0 => 'ясно', 1 => 'малооблачно', 2 => 'облачно', 3 => 'пасмурно' }.freeze
PRECIPITATION = { 3 => 'смешанные', 4 => 'дождь', 5 => 'ливень', 6 => 'снег',
                  7 => 'снег', 8 => 'гроза', 9 => 'нет данных', 10 => 'без осадков' }.freeze

CITIES.each do |_city, link|
  uri = URI.parse(link)
  response = Net::HTTP.get_response(uri)
  # puts response.body

  doc             = REXML::Document.new(response.body)
  city_name       = CGI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])
  current_forcast = doc.root.elements['REPORT/TOWN'].elements.to_a.first

  min_temp        = current_forcast.elements['TEMPERATURE'].attributes['min']
  max_temp        = current_forcast.elements['TEMPERATURE'].attributes['max']

  clouds_index    = current_forcast.elements['PHENOMENA'].attributes['cloudiness'].to_i
  clouds          = CLOUDINESS[clouds_index]

  percip_index    = current_forcast.elements['PHENOMENA'].attributes['precipitation'].to_i
  percip          = PRECIPITATION[percip_index]

  comfort_min     = current_forcast.elements['HEAT'].attributes['min'].to_i
  comfort_max     = current_forcast.elements['HEAT'].attributes['max'].to_i

  puts "Погода в городе #{city_name}:"
  puts "#{clouds}, осадки: #{percip}"
  puts "От #{min_temp} до #{max_temp} градусов"
  puts "Комфортно жить, если одеться на #{comfort_min} - #{comfort_max} ", ''
end
