require 'help_test'

class TestPlantsIds < ActiveSupport::TestCase

  def test_each_plant_should_have_unique_id
    ids = []
    1.upto(10) do |n|
      user = Plant(:user)
      profile = Plant(:profile)
      address = Plant(:address)
      ids += [user.id, profile.id, address.id]
    end
    assert !ids.include?(nil)
    assert_equal ids, ids.uniq
  end
  
end