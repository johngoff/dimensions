class FeedEntry < ActiveRecord::Base
  belongs_to  :feed, class_name: NewsFeed, foreign_key: "news_feed_id"
  has_many    :entity_feed_entries
  has_many    :entities, :through => :entity_feed_entries do
    def primary
     where("entity_feed_entries.default = ?", true)
    end

    def secondary
     where("entity_feed_entries.default = ?", false)
    end
  end

  serialize :fetch_errors

  scope :failed, lambda{|is_fail| where(:failed => is_fail) }

  state_machine :initial => :new do

    after_transition :on => :fetch, :do => :fetch_content!

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

    event :next do
      transition :new         => :downloaded
      transition :downloaded  => :fetched
      transition :fetched     => :localized
      transition :localized   => :tagged
    end

    event :untag do
      transition :tagged => :localized
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

  def self.localize(entry)
    if entry.fetched?
      doc = Calais.process_document(:content => entry.content, :content_type => :raw, :license_id => APP_CONFIG['open_calais_api_key'])
      entry.published_at||= doc.doc_date

      entry.entities.push(entry.feed.location)
      entry.primary_location = entry.feed.location

      unless doc.geographies.empty?
        #test no location is returned as nil!
        locations = Dimensions::Locator.parse_locations(doc.geographies)
        unless locations.empty?
          locations.each {|location| entry.entities << location unless location.nil?}
          entry.primary_location = locations.first
        end
      end

      entry.next
      entry.save!
      return true
    end
  end

  def self.batch_localize
    begin
      self.find_each do |entry|
        self.localize(entry)
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
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
    rescue Exception => e
      self.fetch_errors = {:error => e.to_s}
      self.failed = true
      self.save
      return nil
    end
    self.content
  end

  def locations
    self.entities.location
  end

  def primary_location
    self.entities.location.primary.first
  end

  def primary_location=(location)
    self.entity_feed_entries.all.each do|join_object|
      join_object.update_attributes(:default => false)
    end
    join_object = self.entity_feed_entries.find_by_entity_id(location.id)
    join_object.update_attributes(:default => true)
  end

  def secondary_locations
    self.entities.location.secondary
  end
end
