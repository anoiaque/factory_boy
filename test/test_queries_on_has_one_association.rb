require 'help_test'

class TestQueriesOnHasOneAssociation < ActiveSupport::TestCase
  
  def test_should_stubs_find_with_where_conditions_on_has_one_association
    profile = Plant(:profile, :password => 'azerty')
    joe = Plant(:user, :name => 'Joe', :age => 30, :profile => profile)
   
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'")
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'").joins(:profile)
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'").includes(:profile) 
  end
  
  def test_should_handle_nil_has_one_association
    joe = Plant(:user, :name => 'Joe', :age => 30, :profile => nil)
    
    assert_equal [], User.where(:name => 'Joe').where("profiles.password = 'azerty'")
  end
  
  def test_should_stubs_find_with_where_conditions_on_has_one_association_with_inequality_operators
    profile = Plant(:profile, :password => 'a')
    joe = Plant(:user, :name => 'Joe', :profile => profile)
   
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password >= 'a'")
    assert_equal [], User.where(:name => 'Joe').where("profiles.password > 'a'")
    assert_equal [], User.where(:name => 'Joe').where("profiles.password < 'a'")
    assert_equal [], User.where(:name => 'Joe').where("profiles.password != 'a'")
  end
  
  def test_should_stubs_find_with_where_conditions_on_has_one_association_with_boolean_condition
    profile = Plant(:profile, :checked => false)
    joe = Plant(:user, :name => 'Joe', :profile => profile)
   
    assert_equal [joe], User.where("profiles.checked = '0'")
  end
  
  def test_queries_with_float_and_decimal
    profile = Plant(:profile, :height => 1.75, :salary => 2000.23)
    joe = Plant(:user, :name => 'Joe', :profile => profile)
    
    assert_equal [joe], User.where('profiles.height = 1.75')
    assert_equal [joe], User.where('profiles.salary = 2000.23')
  end
  
end