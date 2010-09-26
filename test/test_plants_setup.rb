require 'help_test'

class PlantSetupTest < Test::Unit::TestCase
  
  def setup
    Plant.destroy
    Plant.reload
  end
  
  def test_plants_are_reloaded_and_4_plants_are_defined
    assert_equal 4, Plant.plants.size
  end
  
  # def test_setup
  #   ObjectSpace.each_object{|object| p object.class if object.class.name =~ /.*BoyTest$/}
  # end
  
end