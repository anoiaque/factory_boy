require 'help_test'

class TestQueriesWithLimit < ActiveSupport::TestCase
  
  def test_should_handle_queries_with_limit_clause
    users = (1..10).map {|n| Plant(:user, :name => 'Joe', :age => n)}
    
    assert_equal 5, User.all.limit(5).size
    assert_equal 6, User.all.limit(6).size
    assert_equal 10, User.all.limit(11).size
    
    assert_equal 3, User.where(:name => 'Joe').limit(3).size
    
  end
  
end