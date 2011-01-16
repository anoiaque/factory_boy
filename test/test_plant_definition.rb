require 'help_test'

class TestPlantDefinition < ActiveSupport::TestCase
  
  def setup
    assert_plants_are_destroyed_before_each_test
  end
  
  def test_simple_definition_of_plant
    assert customer = Plant(:customer)
    assert_nil customer.name
  end
  
  def test_definition_should_assign_attributes_and_values
    user = Plant(:user)
    
    assert_equal "Zorro", user.name
    assert_equal 800, user.age
  end
  
  def test_mocha_is_not_overidden_with_plant_setup
    Plant(:customer)
    Plant.expects(:pool).once
    Plant(:user)
  end

  def test_instanciation_of_a_plant_with_hash_for_assigning_attributes_values
    address = Plant(:address)
    user = Plant(:user, :name => "Marie", :addresses => [address])
    
    assert_equal "Marie", user.name
    assert_equal address, user.addresses.first
  end

  def test_define_with_class_option
    Plant.define :marie, :class => User do |marie|
      marie.name = "Marie"
      marie.addresses = [Address.new(:street => "Rue de Brest")]
    end
    
    marie = Plant(:marie)
    assert_equal "Marie", marie.name
    assert_equal "Rue de Brest", marie.addresses.first.street
  end

  def test_plants_are_reloaded_only_when_a_plant_is_instanciated
    assert_equal 0, Plant.plants.size
    Plant(:user)
    assert_equal 4, Plant.plants.size
  end
  
  def test_definition_of_a_plant_with_dependent_attribute
    Plant.define :user do |user|
      user.name = "Marie"
      user.addresses = [Address.new(:street => "Rue de #{user.name}")]
    end
    
    assert_equal "Rue de Marie", Plant(:user).addresses.first.street
  end

  def test_plant_sequences
    Plant.reload
    assert_equal "incognito1@kantena.com", Plant.next(:email)
    assert_equal "incognito2@kantena.com", Plant.next(:email)
  end
  
  def test_creation_of_two_plants_of_same_class_should_keep_each_object_safe
    user_1 = Plant(:user, :name => "Elise")
    user_2 = Plant(:user, :name => "Vincent")

    assert_equal "Elise", user_1.name
    assert_equal "Vincent", user_2.name
  end
  
  private
  
  def assert_plants_are_destroyed_before_each_test
    assert_equal({}, Plant.plants)
    assert_equal({}, Plant.all)
    assert_equal({}, Plant.send(:class_variable_get, :@@sequences))
    assert_equal 0, Plant.send(:class_variable_get, :@@id_counter)
  end
  
end