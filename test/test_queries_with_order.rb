require 'help_test'

class TestQueriesWithOrder < ActiveSupport::TestCase
  
  def test_should_handle_query_with_one_condition_on_order_clause
    zorro, albert, joe = [Plant(:user, :name => 'Zorro', :age => 30), Plant(:user, :name => 'Albert', :age => 31), Plant(:user, :name => 'Joe', :age => 32)]

    assert_equal [albert, joe, zorro], User.all.order('name asc')
    assert_equal [zorro, joe, albert], User.all.order('name desc')
    assert_equal [zorro, albert, joe], User.all.order('age asc')
    assert_equal [joe, albert, zorro], User.all.order('age desc')
    
    assert_equal [joe, albert, zorro], User.where('age > 20').order('age desc')
  end
  
  
end