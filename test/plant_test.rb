require 'test/unit'
require 'plant'
require 'models/adress'
require 'models/user'
require 'models/profile'


require 'mocha'

class PlantTest < Test::Unit::TestCase

    def setup
      Plant.destroy_all
    end

    def test_define_simple_declaration_with_class_symbol
      assert user = Plant.define(:user)
      assert_nil user.name
    end
    
    def test_define_assign_attributes
      user = factory_default_user
      assert_equal "Zorro", user.name
      assert_equal 800, user.age
    end
    
    def test_define_stubs_find_without_parameter
      user = factory_default_user
      assert_equal user, User.find
    end
    
    def test_define_stubs_find_with_array_result
      2.times { factory_default_user }
      assert_equal 2, User.find(:all).size
    end
    
    def test_define_with_association_has_one
      profile = factory_default_profile
      user = Plant.define :user do |user|
         user.name  = "Zorro"
         user.age = 800
         user.profile = profile
       end
      user = User.find 
      assert_equal profile, user.profile
    end
    
    def test_define_with_association_has_many
      adress = factory_default_adress
      user = Plant.define :user do |user|
         user.name  = "Zorro"
         user.age = 800
         user.adresses = [adress]
       end
      user = User.find 
      assert_equal adress, user.adresses.first
    end
    
    def test_stubs_find_with_option_all
      user = factory_default_user
      users = User.find(:all)
      assert_equal [user], users
    end
    
    private
    
    def factory_default_user
      Plant.define :user do |user|
         user.name  = "Zorro"
         user.age = 800
       end
    end
    
    def factory_default_profile
      Plant.define :profile do |profile|
        profile.password = "BREIZH!"
      end
    end
    
    def factory_default_adress
      Plant.define :adress do |adress|
        adress.number = 17
        adress.street = "rue royale"
      end
    end
    
end