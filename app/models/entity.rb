class Entity < ActiveRecord::Base
  belongs_to  :feed_entry
  serialize   :serialized_data, Hash
  serialize   :tags, Array

  Entity.inheritance_column= "ruby_type"
  scope :locations, where(:type => "location")
  scope :tag, where(:type => "tags")
end
