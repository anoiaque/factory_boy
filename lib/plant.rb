require 'rubygems'
require 'active_support/inflector'
require 'stubber'
require 'setup'

module Plant

  @@plants = {}
  @@pool = {}
  @@map = {}
  @@sequences = {}
  
  def self.define symbol, args={}
    klass = args[:class] || symbol.to_s.camelize.constantize
    instance = klass.new
    yield instance if block_given?
    add_plant(klass, instance)
    add_plant(symbol, instance) if args[:class]
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
  
  def self.destroy
    @@pool = {}
  end
  
  def self.sequence symbol, &proc
    @@sequences[symbol] = {:lambda => proc, :index => 0}
  end
  
  def self.next symbol
    @@sequences[symbol][:lambda].call(@@sequences[symbol][:index] += 1)
  end

end

def Plant symbol, args={}
  plants = Plant.plants
  instance = plants[symbol] || plants[symbol.to_s.camelize.constantize]
  args.each {|key, value| instance.send(key.to_s + '=', value)}
  Plant.pool(instance.class, instance)
  instance
end




