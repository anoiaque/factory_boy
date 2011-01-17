require 'help_test'

class TestSelectorCondition  < ActiveSupport::TestCase
  
  def test_should_transform_sql_conditions_to_ruby_select_conditions_with_one_where
    condition = Plant::Selector::Condition.new("(users.name = 'Joe')", User)
    
    assert_equal "(users.name == 'Joe')", condition.to_ruby
  end

  def test_should_transform_sql_conditions_to_ruby_select_conditions_with_several_wheres
    condition = Plant::Selector::Condition.new(["(users.name = 'Joe' or users.age = 10)", "(users.age = 30)"], User)
    
    assert_equal "(users.name == 'Joe' or users.age == 10) and (users.age == 30)", condition.to_ruby
  end
  
  def test_with_inequality_operators
    condition = Plant::Selector::Condition.new(["(users.age <= 10)"], User)

    assert_equal "(users.age <= 10)", condition.to_ruby
  end
  
  
  
  
end