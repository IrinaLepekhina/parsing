# frozen_string_literal: true

# Parser
class Parser
  attr_accessor :sundance_films

  SEARCH = { torrent: 'https://rutracker.org/forum/tracker.php?nm=',
             youtube: 'https://www.youtube.com/results?search_query=' }.freeze

  def initialize
    @sundance_films = []
  end

  def prepare_links
    ['https://en.m.wikipedia.org/wiki/List_of_Sundance_Film_Festival_award_winners']
  end

  def get_content(link)
    page = Nokogiri::HTML(URI.parse(link).open(&:read))

    section = page.css('section').drop(1).take(5)

    section.each do |decade|
      # '--------------decade--------------'
      year_number = 0

      decade.css('ul').each do |annual|
        # '--------------year--------------'

        year = decade.css("span[class = 'mw-headline']")[year_number]['id'].to_i
        annual.css('li').each do |film|
          prize = film.children.first.text
          prize = 'Alfred P. Sloan Prize' if ['2006 ', '2007 ', '2009 '].include?(prize)

          prize = case prize
                  when / – /
                    prize.split(/ – /).first
                  when /:/
                    prize.split(/:/).first
                  when / - /
                    prize.split(/ - /).first
                  when / –/
                    prize.split(/ –/).first
                  end

          title = if film.css('i').css('a').children.first
                    film.css('i').css('a').children.first.text
                  elsif       film.css('i').children.first
                    film.css('i').children.first.text
                  elsif       film.css('a').children.first
                    film.css('a').children.first.text
                  else
                    film.children.first.text
                  end

          link = if film.css('i').css('a').attribute('href')
                   "https://en.m.wikipedia.org/#{film.css('i').css('a').attribute('href')}"
                 end

          link = nil if link =~ /redlink=1$/

          genre = case prize
                  when /Dramatic/
                    'dramatic'
                  when /Documentary/
                    'documentary'
                  end

          prize_category = case prize
                           when /Directing/
                             'directing'
                           when /Editing/
                             'editing'
                           when /Acting/
                             'acting'
                           when /Screenwriting/ || /Writing/
                             'screenwriting'
                           end

          film_length = ('short' if prize =~ /Short/)
          animation   = ('animation' if prize =~ /Animation/)
          latin       = ('latin' if prize =~ /Latin/)

          torrent_search = SEARCH[:torrent] + title.gsub(' ', '%20').gsub('\'',
                                                                          '%27') + '%20' + year.to_s
          youtube_search = SEARCH[:youtube] + title.gsub(' ', '+').gsub('\'',
                                                                        '%27') + '+' + year.to_s

          film_hash = { media_type: 'Film',
                        title: title,
                        prize: prize,
                        prize_amount: 1,
                        year: year,
                        link: link,
                        genre: genre,
                        film_length: film_length,
                        animation: animation,
                        prize_category: prize_category,
                        latin: latin,
                        torrent_search: torrent_search,
                        youtube_search: youtube_search }

          @sundance_films.push(film_hash) unless film_hash[:prize] =~ /Piper-Heidsieck/

        end
        year_number += 1
      end
    end
  end
end
