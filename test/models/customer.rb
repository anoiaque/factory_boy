class Customer 
  attr_accessor :name
  
  def self.find *args
    "original_find"
  end
end
