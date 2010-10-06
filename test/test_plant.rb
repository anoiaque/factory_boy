require 'help_test'

class PlantTest < Test::Unit::TestCase

    def setup
      assert_find_is_unstubbed_for_each_class
      Plant(:customer)
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
    
    def test_stubs_find_with_option_first
      users = 3.times.map { Plant(:user) }
      assert_equal users.first, User.find(:first)       
    end
    
    def test_stubs_find_with_option_last
      users = 3.times.map { Plant(:user) }
      assert_equal users.last, User.find(:last)       
    end
    
    def test_mocha_is_not_overidden_with_plant_setup
      Plant.expects(:pool).once
      Plant(:user)
    end
    
    def test_create_plant_with_hash_for_values
      adress = Plant(:adress)
      user = Plant(:user, :name => "Marie", :adresses => [adress])
      assert_equal "Marie", user.name
      assert_equal adress, user.adresses.first
    end
    
    def test_define_with_class_option
      Plant.define :marie, :class => User do |peter|
        peter.name = "Marie"
        peter.adresses = [Adress.new(:street => "Rue de Brest")]
      end
      marie = Plant(:marie)
      assert_equal "Marie", marie.name
      assert_equal "Rue de Brest", marie.adresses.first.street
    end
    
    def test_plants_are_reloaded_and_4_plants_are_defined
      assert_equal 4, Plant.plants.size
    end
    
    def test_define_with_dependent_attribute
      Plant.define :user do |user|
        user.name = "Marie"
        user.adresses = [Adress.new(:street => "Rue de #{user.name}")]
      end
      assert_equal "Rue de Marie", Plant(:user).adresses.first.street
    end
    
    def test_plant_sequences
      assert_equal "incognito1@kantena.com", Plant.next(:email)
      assert_equal "incognito2@kantena.com", Plant.next(:email)
    end
    
    def test_creation_of_two_plants_of_same_class_should_keep_each_object_safe
      user_1 = Plant(:user, :name => "Elise")
      user_2 = Plant(:user, :name => "Vincent")

      assert_equal "Elise", user_1.name
    end
    
    private
    
    def assert_find_is_unstubbed_for_each_class
      [Adress, Customer, Profile, User].each {|klass| assert_equal "original_find", klass.find }
    end
    
end