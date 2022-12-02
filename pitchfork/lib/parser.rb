# frozen_string_literal: true

# Parser
class Parser
  attr_accessor :pitchfork_reviews

  SEARCH = {torrent: 'https://rutracker.org/forum/tracker.php?nm=',
            youtube: 'https://www.youtube.com/results?search_query='}

  def initialize
    @pitchfork_reviews = []
  end

  def prepare_links(load_list)
    links = []
    load_list.each do |n|
      link = "https://pitchfork.com/reviews/albums/?page=#{n}"
      links.push(link)
    end
    links
  end

  def get_content(link)
      agent = Mechanize.new
      page = agent.get(link)

      review_links = page.links_with(href: %r{^/reviews/albums/\w+})

      review_links = review_links.reject do |link|
        parent_classes = link.node.parent['class'].split
        parent_classes.any? { |p| %w[next-container page-number].include?(p) }
      end

      reviews = review_links.map do |l|
        review = l.click

        score = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[2]/div/div[2]/div/div/p').text.to_f
        artist = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[1]/div/ul/a/div').text
        album = review.search('//*[@id="main-content"]/article/div[1]/header/div[1]/div[1]/div/h1/em').text
        # review_date = Time.parse(review.search('//*[@id="main-content"]/article/div[1]/header/div[3]/div/div/div/ul/li[3]/div/p[2]')[0]).strftime('%d.%m.%y')
        genre = review.search('//*[@id="main-content"]/article/div[1]/header/div[3]/div/div/div/ul/li[1]/div/p[2]').text
        link = l.to_s

        {
          'artist' => artist,
          'album' => album,
          'genre' => genre,
          'score' => score,
          'link' => link
          # 'review_date' => review_date
        }
      end
      @pitchfork_reviews.push(reviews)
  end
end
