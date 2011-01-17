class User < ActiveRecord::Base
  scope :albert, :conditions => { :name => 'Albert' }
  
  has_one :profile
  has_many :addresses
  
end
