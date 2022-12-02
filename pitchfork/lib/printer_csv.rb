# frozen_string_literal: true
require 'csv'

# Table csv
class Printer
  def write_to_csv(file_name, data)
    headers = %w[media_type artist album genre score link]

    table = CSV.generate do |csv|
      #csv << headers
      data.each do |p|
        p.each do |element|
          csv << element.values
        end
      end
    end
    File.write(file_name, table, mode: 'a')

    puts "Ваша запись сохранена в файл #{file_name}"
  end
end
