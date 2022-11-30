# frozen_string_literal: true

# film
class Film
  attr_accessor :title, :prize, :amount, :year, :link, :genre, :film_length, :animation, :film_stage, :latin,
                :torrent_search, :youtube_search

  DEFAULT_HASH = {
    'title' => nil,
    'prize' => nil,
    'amount' => nil,
    'year' => nil,
    'link' => nil,
    'genre' => nil,
    'film_length' => nil,
    'animation' => nil,
    'film_stage' => nil,
    'latin' => nil,
    'torrent_search' => nil,
    'youtube_search' => nil
  }.freeze

  def initialize; end

  def load_data(row)
    @title = row['title']
    @prize = row['prize']
    @amount = row['amount']
    @year = row['year']
    @link = row['link']
    @genre = row['genre']
    @film_length = row['film_length']
    @animation = row['animation']
    @film_stage = row['film_stage']
    @latin = row['latin']
    @torrent_search = row['torrent_search']
    @youtube_search = row['youtube_search']
  end

  def to_string
    [@title, @prize]
  end

  def prepare_hash(data)
    init_hash = []

    data.each do |film_hash|
      attr_hash = DEFAULT_HASH.merge(film_hash)

      init_hash.push(attr_hash)
    end
    init_hash
  end
end
