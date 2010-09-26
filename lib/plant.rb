require 'rubygems'
require 'active_support/inflector'
require 'stubber'
require 'setup'

module Plant

  @@plants = {}
  @@pool = {}
  
  def self.define symbol
    klass = symbol.to_s.camelize.constantize
    instance = klass.new
    yield instance if block_given?
    add_plant(klass, instance)
    Plant::Stubber.stubs_find(klass)
  end
  
  def self.all
    @@pool
  end
  
  def self.add_plant klass, instance
    @@plants[klass] = instance
  end
  
  def self.plants
    @@plants
  end
  
  def self.reload 
    load "#{RAILS_ROOT}/test/plants.rb" 
  end
  
  def self.pool klass, instance
    @@pool[klass] ||= []  
    @@pool[klass] << instance
  end
  
  def self.association symbol
    Plant(symbol)
  end
  
  def self.destroy
    @@pool = {}
  end

end

def Plant symbol
  klass = symbol.to_s.camelize.constantize
  definition = Plant.plants[klass]
  Plant.pool(klass, definition)
  definition
end




