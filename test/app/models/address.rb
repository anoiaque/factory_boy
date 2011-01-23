class Address < ActiveRecord::Base
  
  belongs_to :user
  
  def self.find
    "original_find"
  end
  
end