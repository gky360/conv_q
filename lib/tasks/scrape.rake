namespace :scrape do
  require "#{Rails.root}/lib/topics_scraper.rb"

  desc "Topic をスクレイピングで取得"
  task :topics => :environment do
    TopicsScraper.scrape
  end

end
