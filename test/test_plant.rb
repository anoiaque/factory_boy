require 'help_test'
require 'plant'

class PlantTest < ActiveSupport::TestCase
  
  def setup
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
  
  def test_stubbed_find_should_return_empty_array_if_none_object_matches_conditions
    assert_equal [], User.where(:name => 'Joe')
  end
  
  def test_should_stubs_find_with_simple_where_condition_on_model_attributes
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
  
  def test_should_stubs_find_with_where_conditions_on_has_many_association
    addresses = [Plant(:address, :street => '21 Jump Street'), Plant(:address, :street => 'Rue des Lilas')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([joe], User.where(:name => 'Joe').where("addresses.street = '21 Jump Street'").joins(:addresses))
    assert_equal([], User.where(:name => 'Joe').where("addresses.street = '20 Jump Street'").joins(:addresses))
    assert_equal([joe], User.where("addresses.street = '21 Jump Street'").joins(:addresses))
    
    assert_equal([], User.where("addresses.street != '21 Jump Street'").joins(:addresses))
    assert_equal([joe], User.where("addresses.street != '20 Jump Street'").joins(:addresses))
    
    joe.addresses = [Plant(:address, :street => 'a'), Plant(:address, :street => 'b')]
    assert_equal([], User.where("addresses.street > 'b' ").joins(:addresses))
    assert_equal([], User.where("addresses.street < 'a' ").joins(:addresses))
    assert_equal([joe], User.where("addresses.street <= 'b' ").joins(:addresses))
    assert_equal([joe], User.where("addresses.street >= 'b' ").joins(:addresses))
  end
  
  
  def test_should_stubs_agregate_functions
    #assert_equal 2, User.count()
  end
  
 
  
end