require 'help_test'

class TestQueriesWithDynamicFinders< ActiveSupport::TestCase
  
  def test_queries_with_dynamic_finder_on_attributes
    user = Plant(:user, :name => 'toto', :age => 30)
    
    assert_equal user, User.find_by_name('toto')
    assert_equal user, User.find_by_name_and_age('toto', 30)
  end
  
end