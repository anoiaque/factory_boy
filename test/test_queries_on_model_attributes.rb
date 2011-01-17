require 'help_test'

class TestQueriesOnModelAttributes < ActiveSupport::TestCase
  
  attr_accessor :joe, :bob
  
  def setup
    @joe = Plant(:user, :name => 'Joe', :age => 30, :male => true)
    @bob = Plant(:user, :name => 'Bob', :age => 31, :male => true)
  end
  
  def test_stubbed_find_should_return_empty_array_if_none_object_matches_conditions
    Plant.destroy
    assert_equal [], User.where(:name => 'Joe')
  end
  
  def test_queries_with_conditions_on_attributes
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
  end
  
  def test_queries_with_dynamics_finders_methods
    assert_equal joe, User.find_by_name('Joe')
  end
  
  def test_should_handle_chainded_where_clauses
    assert_equal [joe], User.where(:age => 30).where(:name => 'Joe')
    users = User.where(:age => 30)
    assert_equal([joe], users.where(:name => 'Joe'))
  end
  
  def test_queries_with_boolean_conditions
    assert_equal [joe, bob], User.where(:male => true)
    assert_equal [], User.where(:male => false)
    assert_equal [joe, bob], User.where("users.male = '1'")
    assert_equal [joe, bob], User.where("male = '1'")
  end
  
end