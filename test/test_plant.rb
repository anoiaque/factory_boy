require 'help_test'

class PlantTest < Test::Unit::TestCase

    def setup
      Plant.destroy
      Plant.reload
    end

    def test_define_simple_definition
      assert customer = Plant(:customer)
      assert_nil customer.name
    end
    
    def test_define_assign_attributes
      user = Plant(:user)
      assert_equal "Zorro", user.name
      assert_equal 800, user.age
    end
    
    def test_define_stubs_find_without_parameter
       user = Plant(:user)
       assert_equal user, User.find
     end
     
    def test_define_stubs_find_with_array_result
      2.times { Plant(:user) }
      assert_equal 2, User.find(:all).size
    end
    
    def test_define_with_association_has_one
      user = Plant(:user)
      profile = Profile.find
      assert_equal profile, user.profile
    end
    
    def test_define_with_association_has_many
      user = Plant(:user)
      assert adresses = user.adresses
      adress = Adress.find
      assert_equal adress, user.adresses.first
    end
    
    def test_stubs_find_with_option_all
      user =  Plant(:user)
      users = User.find(:all)
      assert_equal [user], users
    end
    
    def test_find_all_must_return_an_empty_array_if_no_object
      users = User.find(:all)
      assert_equal [], users
    end
 
    
end