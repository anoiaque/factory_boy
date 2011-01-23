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

  def test_definition_with_class_option
    Plant.define :marie, :class => User do |marie|
      marie.name = "Marie"
      marie.addresses = [Plant(:address, :street => "Rue de Brest")]
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
      user.addresses = [Plant(:address, :street => "Rue de #{user.name}")]
    end
    
    assert_equal "Rue de Marie", Plant(:user).addresses.first.street
  end

  def test_plant_sequences
    Plant.reload
    assert_equal "incognito1@kantena.com", Plant.next(:email)
    assert_equal "incognito2@kantena.com", Plant.next(:email)
  end
  
  def test_should_set_foreign_key_values_for_has_many_associations
    joe, bob = joe_and_bob[:users]
    
    assert_equal joe.id, joe.addresses.first.user_id
    assert_equal bob.id, bob.addresses.first.user_id
  end
  
  def test_should_set_foreign_key_values_for_has_one_associations
    joe, bob = joe_and_bob[:users]

    assert_equal joe.id, joe.profile.user_id
    assert_equal bob.id, bob.profile.user_id
  end
  
  def test_creation_of_two_plants_of_same_class_should_keep_each_object_safe
    joe, bob = joe_and_bob[:users]

    assert_equal "Joe", joe.name
    assert_equal "Bob", bob.name
  end
  
  def test_creation_of_two_plants_of_same_class_should_keep_has_one_associations_safe
    users =  joe_and_bob
    joe, bob, profile_1, profile_2 = users[:users], users[:profiles]

    assert_equal profile_1, joe.profile
    assert_equal profile_2, bob.profile
  end
  
  def test_creation_of_two_plants_of_same_class_should_keep_has_many_associations_safe
    users =  joe_and_bob
    joe, bob = users[:users]
    address_1, address_2 = users[:addresses]
     
    assert_equal [address_1], joe.addresses
    assert_equal [address_2], bob.addresses
  end
  
  
  private
  
  def assert_plants_are_destroyed_before_each_test
    assert_equal({}, Plant.plants)
    assert_equal({}, Plant.all)
    assert_equal({}, Plant.send(:class_variable_get, :@@sequences))
    assert_equal 0, Plant.send(:class_variable_get, :@@id)
  end
  
  def joe_and_bob
    address_1 = Plant(:address, :street => '40 rue de PenMarch')
    address_2 = Plant(:address, :street => '25 Bd du Guilvinec')

    profile_1 = Plant(:profile, :password => 'azerty')
    profile_2 = Plant(:profile, :password => 'qwerty')
    
    joe = Plant(:user, :name => 'Joe', :addresses => [address_1], :profile => profile_1)
    bob = Plant(:user, :name => 'Bob', :addresses => [address_2], :profile => profile_2)
    
 
    {:users => [joe, bob], :addresses => [address_1, address_2], :profiles => [profile_1, profile_2]}
  end
  
end