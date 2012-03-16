class Dimensions::Locator
  def self.open_calais_location(geographies)
    geography = geographies.first
    serialized_data = geography.attributes.except("docId")
    entity = Entity.new(:name => geography.name, :serialized_data => serialized_data, :type => "location")
  end

  def self.open_calails_tag(categories)
    tags = {
      0 => categories
    }
    entity = Entity.new(:name => geography.name, :serialized_data => tags, :type => "tags")
  end
end
