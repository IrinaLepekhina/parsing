# frozen_string_literal: true

require 'csv'

# Table csv or ruby objects
class Printer
  def write_to_csv(file_name, data)
    headers = %w[title prize prize_amount year link genre film_length animation prize_category latin torrent_search
                 youtube_search]

    table = CSV.generate do |csv|
      csv << headers
      data.each do |element|
        csv << element.values
      end
    end
    File.write(file_name, table, mode: 'w')

    puts "Ваша запись сохранена в файл #{file_name}"
  end
end
