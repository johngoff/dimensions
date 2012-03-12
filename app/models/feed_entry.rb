class FeedEntry < ActiveRecord::Base
  belongs_to :feed, class_name: NewsFeed, foreign_key: "news_feed_id"
  serialize :fetch_errors

  state_machine :initial => :new do

    event :download do
      transition :new => :downloaded
    end

    event :fetch do
      transition :downloaded => :fetched
    end

    event :localize do
      transition :fetched => :localized
    end

    event :tag do
      transition :localized => :tagged
    end

  end

  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    raise "The feed is invalid" if feed.nil?

    entries = []
    feed.entries.each do|entry|
      unless exists? guid: entry.id
        entries << create!(name: entry.title,
               summary: entry.summary,
               url: entry.url,
               published_at: entry.published,
               guid: entry.id,
               author: entry.author,
               content: entry.content)

      end
    end
    entries
  end

  def fetch_content!
    return self.content if self.content.present?
    begin
      scraper = Scraper.define do
        array :content

        process "p", :content => :text
        result :content
      end
      uri = URI.parse(self.url)
      self.content = scraper.scrape(uri).join(" ")
      self.save
      self.fetch
    rescue Exception => e
      self.fetch_errors = {:error => e.to_s}
      self.failed = true
      self.save
      return nil
    end

    return self.content
  end

  def self.batch_localize
    begin
      self.find_each do |e|
        self.localize(e.id)
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end

  def self.localize(id)
    begin
      entry = self.find(id)
      if entry.fetched?
        location = Calais.process_document(:content => entry.content, :content_type => :raw, :license_id => "du295ff4zrg3rd4bwdk86xhy")
        unless location.geographies.first.nil?
          geography = location.geographies.first.attributes
          entry.shortname =   geography["shortname"]
          entry.country   =     geography["containedbycountry"]
          entry.latitude  =    geography["latitude"]
          entry.longitude =   geography["longitude"]
          entry.localize
          entry.save
          return true
        end
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end

  def self.batch_index!
    begin
      self.find_each do |e|
        self.searchify_me(e.id)
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end

  def self.searchify_me(id)
    begin
      entry = self.find(id)
      api = IndexTank::Client.new "http://:8c3vN9XtuEPi53@do1vj.api.searchify.com"
      index = api.indexes "idx"
      fields = { :text => entry.content }

      variables = {
        0 => entry.latitude,
        1 => entry.longitude
      }

      index.document(entry.id).add(fields, :variables => variables)

    rescue Exception => e
      puts e.to_s
      return nil
    end
  end
end
