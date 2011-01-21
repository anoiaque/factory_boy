require 'help_test'

class TestQueriesWithNamedScope < ActiveSupport::TestCase
  
  def test_should_handle_named_scopes
    user = Plant(:user, :name => 'Albert')
    
    assert_equal [user], User.albert
  end
  
end