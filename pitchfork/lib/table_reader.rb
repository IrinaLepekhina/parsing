# frozen_string_literal: true

#TableReader
class TableReader
  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  def prepare_hash(file_path)
    CSV.read(file_path, headers: true, header_converters: :symbol,
                        converters: %i[all blank_to_nil]).map do |a|
      Hash[a]
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

  def print_array(array)
    array.each do |element|
      puts element.to_string
    end
  end
end
