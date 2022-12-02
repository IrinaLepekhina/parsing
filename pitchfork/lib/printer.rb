# frozen_string_literal: true
require 'csv'

class Printer

  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  def write_to_csv(file_name, data)
    headers = %w[artist album genre score link]

    table = CSV.generate do |csv|
      csv << headers
      data.each do |p|
        p.each do |element|
          csv << element.values
        end
      end
    end
    File.write(file_name, table, mode: 'a')

    puts "Ваша запись сохранена в файл #{file_name}"
  end

  def prepare_hash(file_path)
    abort "Файл #{file_path} не найден" unless File.exist?(file_path)
    attributes = CSV.read(file_path, headers: true, header_converters: :symbol, converters: %i[all blank_to_nil]).map do |a|
      Hash[a]
    end
    attributes
  end

  def print_array(file_path, attributes)
    array = filling_array(attributes)

    array.each do |element|
      puts element.to_string
    end
  end
  
  def filling_array(attributes)
    array = []
    attributes.each do |row|
      obj = Creator.new.factory_method
      obj.load_data(row)
      array.push(obj)
    end
    array
  end
end
