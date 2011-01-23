require 'help_test'

class TestQueriesWithNamedScope < ActiveSupport::TestCase
  
  def setup
    @albert = Plant(:user, :name => 'Albert', :age => 30)
  end
  
  def test_should_handle_named_scopes
    assert_equal [@albert], User.albert
  end
  
  def test_should_handle_scope_with_chained_where
    assert_equal [@albert], User.albert.where(:age => 30)
    assert_equal [], User.albert.where(:age => 20)
  end
  
end