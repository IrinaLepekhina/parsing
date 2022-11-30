# frozen_string_literal: true

# Table csv or ruby objects
class Printer
  attr_accessor :arr

  def initialize
    @arr = []
  end

  def write_to_csv(data)
    headers = %w[title prize amount year link genre film_length animation film_stage latin torrent_search
                 youtube_search]
    file_name = 'sundance_films.csv'

    table = CSV.generate do |csv|
      csv << headers
      data.each do |film|
        csv << film.values
      end
    end
    File.write(file_name, table, mode: 'w')

    puts "Ваша запись сохранена в файл #{file_name}"
  end

  def print_array(attributes)
    puts '', 'Ruby array:'

    array = filling_array(attributes)

    array.each do |element|
      puts element.to_string
    end
  end

  def filling_array(attributes)
    array = []
    attributes.each do |row|
      film = Creator.new.factory_method
      film.load_data(row)
      array.push(film)
    end
    array
  end
end
