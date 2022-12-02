class Music
  attr_accessor :artist, :album, :genre, :score, :link, :media_type

  def initialize; end

  def load_data(row)
    @artist = row[:artist]
    @album = row[:album]
    @genre = row[:genre]
    @score = row[:score]
    @link = row[:link]
    @media_type = row[:media_type]
  end

  def to_string
    [@artist, @album, @score, @genre]
  end

  # def prepare_hash(data)
  #   init_hash = []

  #   data.each do |film_hash|
  #     attr_hash = DEFAULT_HASH.merge(film_hash)

  #     init_hash.push(attr_hash)
  #   end
  #   init_hash
  # end
end