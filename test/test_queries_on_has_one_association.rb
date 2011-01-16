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
  
end