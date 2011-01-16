require 'help_test'


class StubbingTest < ActiveSupport::TestCase
  
  def setup
    assert_stubs_are_unstubbed_before_each_test
    User.destroy_all
    Profile.destroy_all
  end
  
  def test_stubs_should_be_on_only_when_plant_definitions_are_loaded
    user = User.create(:name => 'Largo')
    assert_equal [user], User.where(:name => 'Largo')
    
    user = Plant(:user, :name => 'Tintin')
    assert_equal [], User.where(:name => 'Largo')
    assert_equal [user], User.where(:name => 'Tintin')
  end
  
  def test_includes_are_stubbed_only_when_plant_definitions_are_loaded
    profile = Profile.create(:password => 'azerty')
    joe = User.create(:name => 'Joe', :age => 30, :profile => profile)
    
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'azerty'").includes(:profile) 
    
    profile = Plant(:profile, :password => 'xy')
    joe = Plant(:user, :name => 'Joe', :profile => profile)

    assert_equal [], User.where(:name => 'Joe').where("profiles.password = 'azerty'").includes(:profile) 
    assert_equal [joe], User.where(:name => 'Joe').where("profiles.password = 'xy'").includes(:profile) 
  end
  
  private
  
  def assert_stubs_are_unstubbed_before_each_test
    User.destroy_all
    user = User.create(:name => 'Largo')
    assert_equal user, User.first
    assert_equal [user], User.where(:name => 'Largo')
  end
  
end