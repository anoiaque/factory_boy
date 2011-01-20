require 'help_test'

class TestQueriesWithRanges < ActiveSupport::TestCase
  
  def test_should_handle_sql_in_predicate
    user_1, user_2 = [Plant(:user, :age => 20), Plant(:user, :age => 25)]
    
    assert_equal [user_1, user_2], User.where(:age => [12, 20, 25, 30])
    assert_equal [user_1, user_2], User.where('age in (12, 20, 25, 30)')
    assert_equal [user_1], User.where(:age => [12, 20, 30])
  end
  
  def test_should_handle_sql_between_predicate
    user_1, user_2 = [Plant(:user, :age => 20), Plant(:user, :age => 25)]
    
    assert_equal [user_1, user_2], User.where(:age => (12..40))
    assert_equal [user_1], User.where(:age => (12..20))
  end
  
  
end