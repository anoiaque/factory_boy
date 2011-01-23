require 'help_test'

class TestQueriesWithLimit < ActiveSupport::TestCase
  
  def setup
    @users = (1..10).map {|n| Plant(:user, :name => 'Joe', :age => n)}
  end
  
  def test_queries_with_limit_clause
    assert_equal 5, User.limit(5).size
    assert_equal 5, User.all.limit(5).size
    assert_equal 6, User.all.limit(6).size
    assert_equal 10, User.all.limit(11).size
    assert_equal 3, User.where(:name => 'Joe').limit(3).size
  end
  
  def test_queries_with_limit_and_offset_clause
    first_age = @users.first.age
    
    assert_equal 5, User.limit(5).offset(2).size
    assert_equal first_age + 2,  User.limit(5).offset(2).first.age
    assert_equal first_age + 2 + 4,  User.limit(5).offset(2).last.age
    
  end
  
 
  
end