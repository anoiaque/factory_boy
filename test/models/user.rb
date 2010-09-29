class User 
  
  attr_accessor :name, :age, :adresses, :profile

  def self.find *args
    "original_find"
  end
end
