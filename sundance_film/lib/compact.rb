# frozen_string_literal: true

# Compact
module Compact
  [Hash, Array].each do |klass|
    refine klass do
      def compact!
        Compact.compact!(self)
      end
    end
  end

  def compact!(obj)
    obj.group_by { |hash| hash[:title] }.map do |_title, hashes|
      hashes.reduce do |a, b|
        a.merge(b) { |_key, v1, v2| v1 == v2 ? v1 : [v1, v2].flatten }
      end
    end
  end

  module_function :compact!
end

# modul to flatten array
module DeepCompact
  # удалила нули
  [Hash, Array].each do |klass|
    refine klass do
      def deep_compact!
        DeepCompact.deep_compact!(self)
      end
    end
  end

  def deep_compact!(obj)
    case obj
    when Hash
      obj.delete_if do |_, val|
        val.nil? || (val.respond_to?(:empty?) && val.empty?) || DeepCompact.deep_compact!(val)
      end
      obj.empty?
    when Array
      obj.delete_if do |val|
        val.nil? || (val.respond_to?(:empty?) && val.empty?) || DeepCompact.deep_compact!(val)
      end
      obj.empty?
    else
      false
    end
  end

  module_function :deep_compact!
end

# Brushing
module Brushing
  [Hash, Array].each do |klass|
    refine klass do
      def brushing
        Brushing.brushing(self)
      end
    end
  end

  def brushing(obj)
    obj.each do |film|
      film.each do |k, v|
        film[k] = if v.is_a?(Array) && v.size == 1
                    v.join(' ')
                  else
                    v
                  end

        film[:prize_amount] = if film[:prize].is_a?(Array)
                                film[:prize].size.to_s
                              else
                                1
                              end
      end
    end
  end
  module_function :brushing
end

module CleanBracket
  [Hash, Array].each do |klass|
    refine klass do
      def clean_bracket
        CleanBracket.clean_bracket(self)
      end
    end
  end

  def clean_bracket(array)
    array.each do |hash|
      hash.each do |key, str|
        hash[key] = (if str.is_a? Array
                       str.join(',
')
                     else
                       str
                     end).to_s
      end
    end
  end

  module_function :clean_bracket
end
