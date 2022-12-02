class Media
  attr_accessor :media_type

  def initialize;  end

  def to_string; end

  def self.types
    ObjectSpace.each_object(Class).select { |klass| klass < self }.map.with_index(1) { |x, i| [i, x.name] }.to_h
  end

  def to_db_hash
    { 'media_type' => self.class.name}
  end

  def load_data(data_hash); end

  ## Save as local text file
  ## Not using

  def save
    file = File.new(file_path, 'w:UTF-8')
    to_string.each do |string|
      file.puts(string)
    end

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)
    file_name    = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H_%M.txt")
    "#{current_path}/../user_data/#{file_name}"
  end
end