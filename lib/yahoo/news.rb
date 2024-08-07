module Yahoo
  require 'rss'
  require 'open-uri'
  class News

    def initialize
      @feed_url = 'https://news.yahoo.com/rss/world'
    end
  
    def get_articles
      articles = []
      begin
        feed = RSS::Parser.parse(URI.open(@feed_url), validate: false)
   
        #puts "Recent articles from Yahoo World RSS News Feed:"
        #puts "--------------------------------------------------"
  
        feed.items.first(5).each_with_index do |item, index|
          puts ">>> #{index + 1}. #{item.title}"
          #puts "   Link: #{item.link}"
          #puts "--------------------------------------------------"
          articles << item.title
        end
      rescue StandardError => e
        puts "Error fetching or parsing the RSS feed: #{e.message}"
      end
      articles
    end
  end #Class
end #Module