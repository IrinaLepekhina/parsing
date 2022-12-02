# frozen_string_literal: true

# film
class Film
  attr_accessor :media_type, :title, :prize, :amount, :year, :link, :genre, :film_length, :animation, :film_stage, :latin,
                :torrent_search, :youtube_search

  DEFAULT_HASH = {
    media_type: nil,
    title: nil,
    prize: nil,
    prize_amount: nil,
    year: nil,
    link: nil,
    genre: nil,
    film_length: nil,
    animation: nil,
    prize_category: nil,
    latin: nil,
    torrent_search: nil,
    youtube_search: nil
  }.freeze

  def initialize; end

  def load_data(row)
    @media_type = 'Film'
    @title = row[:title]
    @prize = row[:prize]
    @prize_amount = row[:prize_amount]
    @year = row[:year]
    @link = row[:link]
    @genre = row[:genre]
    @film_length = row[:film_length]
    @animation = row[:animation]
    @prize_category = row[:prize_category]
    @latin = row[:latin]
    @torrent_search = row[:torrent_search]
    @youtube_search = row[:youtube_search]
  end

  def to_string
    [@media_type, @title, @year, @prize, @torrent_search, @youtube_search]
  end

  def hash_for_obj(data)
    init_hash = []

    data.each do |film_hash|
      attr_hash = DEFAULT_HASH.merge(film_hash)

      init_hash.push(attr_hash)
    end
    init_hash
  end
end
