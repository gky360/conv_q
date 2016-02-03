require "#{Rails.root}/lib/topics_scraper.rb"

namespace :topics do

  desc "Topic をスクレイピングで取得"
  task :scrape => :environment do
    TopicsScraper.scrape
  end

  desc "Topic をすべて消去して、自動採番値を1にリセットする"
  task :reset => :environment do
    Topic.delete_all
    Topic.connection.execute("TRUNCATE TABLE `topics`;")
  end

end
