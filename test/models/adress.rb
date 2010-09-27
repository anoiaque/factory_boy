class Adress
  attr_accessor :number, :street
  
  def initialize args={}
    @street = args[:street]
    @number = args[:number]
  end
end