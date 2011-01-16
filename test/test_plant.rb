require 'help_test'
require 'plant'

class PlantTest < ActiveSupport::TestCase
  
  def setup
    #assert_find_is_unstubbed_for_each_class
  end
  
  def test_define_simple_definition
    assert customer = Plant(:customer)
    assert_nil customer.name
  end
  
  def test_definition_should_assign_attributes_and_values
    user = Plant(:user)
    assert_equal "Zorro", user.name
    assert_equal 800, user.age
  end
  
  def test_define_stubs_find_without_parameter
     user = Plant(:user)
     assert_equal user, User.find
   end

  def test_define_stubs_find_with_array_result
    2.times { Plant(:user) }
    assert_equal 2, User.find(:all).size
  end
  
  def test_should_stubs_find_whith_option_first_and_with_class_method_first
    user = Plant(:user)
    assert_equal user, User.find(:first)
    assert_equal user, User.first
  end
  
  def test_should_stubs_find_whith_option_all_and_with_class_method_last
    user = Plant(:user)
    assert_equal user, User.find(:last)
    assert_equal user, User.last
  end
  
  def test_should_stubs_find_whith_option_last_and_with_class_method_all
    user = Plant(:user)
    assert_equal [user], User.find(:all)
    assert_equal [user], User.all
  end
  
  def test_mocha_is_not_overidden_with_plant_setup
    Plant(:customer)
    Plant.expects(:pool).once
    Plant(:user)
  end

  def test_create_plant_with_hash_for_values
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

  def test_define_with_dependent_attribute
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
   
  def test_stubbed_find_should_return_empty_array_if_none_object_matches_conditions
    assert_equal [], User.where(:name => 'Joe')
  end
  
  def test_should_stubs_find_with_where_condition_on_model_attributes
    joe = Plant(:user, :name => 'Joe', :age => 30)
    bob = Plant(:user, :name => 'Bob', :age => 31)
 
    assert_equal [joe], User.where(:name => 'Joe')
    assert_equal [joe], User.where("users.name = 'Joe'")
    assert_equal [joe], User.where("name = 'Joe'")
    assert_equal [joe], User.where(:name => 'Joe', :age => 30)
    assert_equal [joe], User.where("users.name = 'Joe' or users.age = 30")
    assert_equal [bob], User.where("name = 'Bob' and age = 31")
    assert_equal [joe, bob], User.where("age = 30 or age = 31")
    assert_equal [joe, bob], User.where("(age = 30 and name = 'Joe') or (age = 31 and name = 'Bob')")
    assert_equal [joe, bob], User.where("age <= 31")
    assert_equal [], User.where("age > 31")
    assert_equal joe, User.find_by_name('Joe')
  end
  
  def test_should_handle_chainded_where_clauses
    joe = Plant(:user, :name => 'Joe', :age => 30)
    bob = Plant(:user, :name => 'Bob', :age => 30)
    
    assert_equal [joe], User.where(:age => 30).where(:name => 'Joe')
    
    users = User.where(:age => 30)
    assert_equal([joe], users.where(:name => 'Joe'))
  end
  
  def test_should_stubs_find_with_where_conditions_on_has_one_association
    profile = Plant(:profile, :password => 'azerty')
    joe = Plant(:user, :name => 'Joe', :age => 30, :profile => profile)
   
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'")
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'").joins(:profile)
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'").includes(:profile) 
  end
  
  def test_should_handle_nil_has_one_association
    profile = Plant(:profile, :password => 'azerty')
    joe = Plant(:user, :name => 'Joe', :age => 30, :profile => nil)
   
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'")
  end
  
  def test_should_stubs_find_with_where_conditions_on_has_many_association_with_equality_operator
    addresses = [Plant(:address, :street => '21 Jump Street'), Plant(:address, :street => 'Rue des Lilas')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([joe], User.where(:name => 'Joe').where("addresses.street = '21 Jump Street'").joins(:addresses))
    assert_equal([], User.where(:name => 'Joe').where("addresses.street = '20 Jump Street'").joins(:addresses))
    assert_equal([joe], User.where("addresses.street = '21 Jump Street'").joins(:addresses))
  end
  
  def test_should_stubs_find_with_where_conditions_on_has_many_association_with_non_equality_operator
    addresses = [Plant(:address, :street => '21 Jump Street'), Plant(:address, :street => 'Rue des Lilas')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([], User.where("addresses.street != '21 Jump Street'").joins(:addresses))
    assert_equal([joe], User.where("addresses.street != '20 Jump Street'").joins(:addresses))
  end
  
  def test_should_stubs_find_with_where_conditions_on_has_many_association_with_inequality_operators
    addresses = [Plant(:address, :street => 'a'), Plant(:address, :street => 'b')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([], User.where("addresses.street > 'b' ").joins(:addresses))
    assert_equal([], User.where("addresses.street < 'a' ").joins(:addresses))
    assert_equal([joe], User.where("addresses.street <= 'b' ").joins(:addresses))
    assert_equal([joe], User.where("addresses.street >= 'b' ").joins(:addresses))
  end
  
  
  def test_should_stubs_agregate_functions
    #assert_equal 2, User.count()
  end
  
  private
  
  def assert_find_is_unstubbed_for_each_class
    [Address].each {|klass| assert_equal "original_find", klass.find }
  end
  
 
  
end