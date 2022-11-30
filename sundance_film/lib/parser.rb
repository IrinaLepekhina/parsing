# frozen_string_literal: true

# Parser
class Parser
  def parse_to_film
    films = []
    films_not_nil = []
    html = URI.parse('https://en.m.wikipedia.org/wiki/List_of_Sundance_Film_Festival_award_winners').open(&:read)
    doc = Nokogiri::HTML(html)

    section = doc.css('section').drop(1).take(5)

    section.each do |decade|
      # '--------------decade--------------'
      year_number = 0

      decade.css('ul').each do |annual|
        # '--------------year--------------'

        year = decade.css("span[class = 'mw-headline']")[year_number]['id'].to_i
        annual.css('li').each do |film|
          prize = film.children[0].text
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

          title = if film.css('i').css('a').children[0]
                    film.css('i').css('a').children[0].text
                  elsif film.css('i').children[0]
                    film.css('i').children[0].text
                  elsif film.css('a').children[0]
                    film.css('a').children[0].text
                  else
                    film.children[0].text
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

          film_stage = case prize
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
          animation = ('animation' if prize =~ /Animation/)
          latin = ('latin' if prize =~ /Latin/)

          torrent_search = 'https://rutracker.org/forum/tracker.php?nm=' + title.gsub(' ', '%20').gsub('\'',
                                                                                                       '%27') + '%20' + year.to_s
          youtube_search = 'https://www.youtube.com/results?search_query=' + title.gsub(' ', '+').gsub('\'',
                                                                                                       '%27') + '+' + year.to_s

          films.push({
                       'title' => title,
                       'prize' => prize,
                       'amount' => 1,
                       'year' => year,
                       'link' => link,
                       'genre' => genre,
                       'film_length' => film_length,
                       'animation' => animation,
                       'film_stage' => film_stage,
                       'latin' => latin,
                       'torrent_search' => torrent_search,
                       'youtube_search' => youtube_search
                     })
        end

        # films_not_nil = films.reject { |film| film['title'] == '' }
        films_not_nil = films.reject { |film| film['prize'] =~ /Piper-Heidsieck/ }
        year_number += 1
      end
    end
    films_not_nil
  end
end
