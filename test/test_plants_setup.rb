require 'help_test'


class PlantSetupTest < Test::Unit::TestCase

  def setup
    Plant(:customer)
  end
  
  def test_plants_are_reloaded_and_4_plants_are_defined
    assert_equal 4, Plant.plants.size
  end
  
  
end