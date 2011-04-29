require 'help_test'

class TestBasicQueries < ActiveSupport::TestCase
  
  
  def test_should_stubs_find_whith_option_first_and_with_class_method_first
    user = Plant(:user)
    assert_equal user, User.find(:first)
    assert_equal user, User.first
  end

  def test_should_stubs_find_whith_option_all_and_with_class_method_last
    user_1, user_2 = [Plant(:user), Plant(:user)]
    assert_equal user_2, User.find(:last)
    assert_equal user_2, User.last
  end
  
  def test_should_stubs_find_whith_option_last_and_with_class_method_all
    users = [Plant(:user), Plant(:user)]
    assert_equal users, User.find(:all)
    assert_equal users, User.all
  end
  
  def test_should_find_by_id
    user = Plant(:user)
    
    assert_equal user, User.find(user.id)
  end
  
  def test_should_find_by_ids
    user_1, user_2 = [Plant(:user), Plant(:user)]
    
    assert_equal [user_1, user_2], User.find(user_1.id, user_2.id)
  end
  
  
end