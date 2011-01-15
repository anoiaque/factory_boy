require 'help_test'


class PlantTest < ActiveSupport::TestCase
  
  attr_accessor :user
  
  def setup
   # @user = Plant(:user)
  end
  
  #p User.where(:name => 'Zorro')
  # User.where("name = 'Zorro' or age <= 10").where_values.each do |predicate|
  #   
  #   p predicate.class
  #   p predicate.operand.name
  #   p predicate.operand2
  # end
  # users = Arel::Table.new(:users)
  #  User.where(users[:name].eq('bob').or(users[:age].lt(25))).where_values.each do |predicate|
  # 
  #     p predicate.class
  #     p predicate.operand.operand.class
  #     p predicate.operand2.class
  #   end


  #p User.where("name = 'zorro' or age <= 10")
  
  def test_should_stubs_arel_where_predicate
    User.destroy_all
  #  user = Plant(:user, :name => 'Joe')
  #  assert_equal user, User.where(:name => 'Joe')
  profile = Profile.create(:password => 'azerty')
  address = Address.create(:street => 'Avenue de Quimper')
  user =  User.create(:name => 'Zorro', :profile => profile, :addresses => [address] )

  assert_equal [user], User.where(:name => 'Zorro').where("profiles.password = 'azerty'").includes(:profile)
  assert_equal [user], User.where(:name => 'Zorro').where("profiles.password = 'azerty'").where("addresses.street = 'Avenue de Quimper'").joins(:profile, :addresses)
  assert_equal [user], User.where("name = 'Zorro'")
  # p  User.where(:name => 'Zorro').where("profiles.password = 'azerty'").includes(:profile).where_clauses
  #  p  User.where(:name => 'Zorro').where("profiles.password = 'azerty'").includes(:profile).includes_values
  p  User.where(:name => 'Zorro').where("profiles.password = 'azerty'").where("addresses.street = 'Avenue de Quimper'").joins(:profile, :addresses).where_clauses
  # p  User.where(:name => 'Zorro').where("profiles.password = 'azerty'").where("addresses.street = 'Avenue de Quimper'").joins(:profile, :addresses).joins_values
  users = Arel::Table.new(:users)
  p User.where(users[:name].eq('bob').or(users[:age].lt(25))).where_clauses
  p User.where("name = 'Zorro' and age <= 10 and profiles.password == 'azerty'").joins(:profile).where_clauses
    # p User.where("name = 'Zorro' or age <= 10").order("name asc").order_values
    
  end
  
  def test_temp
    profile = Profile.new(:password => 'azerty')
    address = Address.new(:street => 'Avenue de Quimper') 
    user_1 = User.new(:name => 'Joe', :addresses => [])
    user_2 = User.new(:name => 'Bob', :profile => profile, :addresses => [address])
    users = [user_1, user_2]
    assert_equal [user_1], users.select {|user| user.name == 'Joe'}
    assert_equal [user_2], users.select {|user| user.profile.try(:password) == 'azerty'}
    assert_equal [user_2], users.select {|user| user.name == 'Bob' and user.addresses.map(&:street).any?{'Avenue de Quimper'}}
  end
  
end