require 'help_test'

class TestQueriesWithLike < ActiveSupport::TestCase
  
  
  def test_should_handle_sql_like_predicate
    user = Plant(:user, :name => 'Gwaenaelle', :profile => Plant(:profile, :password => 'password'))
  
    assert_equal([user], User.where("name like 'Gwaenaelle'"))
    assert_equal([user], User.where("name like ?",'%Gwaenaelle'))
    assert_equal([user], User.where("name like ?",'%Gwaena%'))
    assert_equal([], User.where("name like ?",'%Gwaen'))
    
    assert_equal([user], User.where("profiles.password like ?", '%pass%').joins(:profile))
    assert_equal([user], User.where("name LIKE 'Gwaenaelle'"))
    
    user.name = ' Like '
    assert_equal([user], User.where("name LIKE ' Like '"))
  end

 
end