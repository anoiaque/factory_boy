require 'help_test'

class TestQueriesOnHasManyAssociation < ActiveSupport::TestCase
  
  def test_queries_with_conditions_on_has_many_association_with_equality_operator
    addresses = [Plant(:address, :street => '21 Jump Street'), Plant(:address, :street => 'Rue des Lilas')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([joe], User.where(:name => 'Joe').where("addresses.street = '21 Jump Street'").joins(:addresses))
    assert_equal([], User.where(:name => 'Joe').where("addresses.street = '20 Jump Street'").joins(:addresses))
    assert_equal([joe], User.where("addresses.street = '21 Jump Street'").joins(:addresses))
  end
  
  def test_queries_with_conditions_on_has_many_association_with_non_equality_operator
    addresses = [Plant(:address, :street => '21 Jump Street'), Plant(:address, :street => 'Rue des Lilas')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([], User.where("addresses.street != '21 Jump Street'").joins(:addresses))
    assert_equal([joe], User.where("addresses.street != '20 Jump Street'").joins(:addresses))
  end
  
  def test_queries_with_conditions_on_has_many_association_with_inequality_operators
    addresses = [Plant(:address, :street => 'a'), Plant(:address, :street => 'b')]
    joe = Plant(:user, :name => 'Joe', :age => 30, :addresses => addresses)
    
    assert_equal([], User.where("addresses.street > 'b' ").joins(:addresses))
    assert_equal([], User.where("addresses.street < 'a' ").joins(:addresses))
    assert_equal([joe], User.where("addresses.street <= 'b' ").joins(:addresses))
    assert_equal([joe], User.where("addresses.street >= 'b' ").joins(:addresses))
    
  end

  def test_queries_with_conditions_on_has_many_association_with_like_predicate
    joe = Plant(:user, :name => 'Joe', :addresses => [Plant(:address, :street => 'azb')])
    bob = Plant(:user, :name => 'Bob', :addresses => [Plant(:address, :street => 'azc')])
   
    assert_equal([joe, bob], User.where("addresses.street like  ?", 'az%').joins(:addresses))
    assert_equal([joe], User.where("addresses.street like  ?", 'azb').joins(:addresses))
    
  end
 
  
end