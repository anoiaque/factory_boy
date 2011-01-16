require 'stubber'
require 'selector'
require 'setup'

module Plant

  @@plants = {}
  @@pool = {}
  @@map = {}
  @@sequences = {}

  @@stubs = {:find => false, :where => false, :includes => false}
  @@wheres = nil
  
  def self.define symbol, args={}
    klass = args[:class] || symbol.to_s.camelize.constantize
    instance = klass.new
    yield instance if block_given?
    add_plant(klass, instance)
    add_plant(symbol, instance) if args[:class]
    stubs
  end
  
  def self.stubs
    unless @@stubs[:where] 
      Plant::Stubber.stubs_where
      @@stubs[:where] = true 
    end
    unless @@stubs[:includes]
      Plant::Stubber.stubs_includes
      @@stubs[:includes] = true 
    end
    unless@@stubs[:find]
      Plant::Stubber.stubs_find 
      @@stubs[:find] = true 
    end
  end
  
  def self.unstubs
    Plant::Stubber.unstubs_find if @@stubs[:find]
    Plant::Stubber.unstubs_includes if @@stubs[:includes]
    Plant::Stubber.unstubs_where if @@stubs[:where]
    @@stubs = {:find => false, :where => false, :includes => false}
  end
  
  def self.wheres= wheres
    @@wheres = wheres
  end
  
  def self.wheres
    @@wheres
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
    load "#{RAILS_ROOT}/test/plants.rb" if Plant.plants.empty?
  end
  
  def self.pool symbol
    instance = plants[symbol] || plants[symbol.to_s.camelize.constantize]
    object = instance.clone
    yield  object if block_given?
    @@pool[instance.class] ||= []  
    @@pool[instance.class] << object
    object
  end
  
  def self.destroy
    @@pool = {}
    @@plants = {}
    @@map = {}
    @@sequences = {}
  end
  
  def self.sequence symbol, &proc
    @@sequences[symbol] = {:lambda => proc, :index => 0}
  end
  
  def self.next symbol
    @@sequences[symbol][:lambda].call(@@sequences[symbol][:index] += 1)
  end
  
  def self.association symbol
    Plant.pool(symbol)
  end
  
  def self.find_all klass
    Plant.all[klass] || []
  end
  
  def self.select klass
    Plant::Selector.new(:klass => klass, :wheres => @@wheres, :plants => @@pool[klass].to_a).select
  end
 
end

def Plant symbol, args={}
  Plant.reload 
  Plant.pool(symbol) do |instance|
    args.each {|key, value| instance.send(key.to_s + '=', value)}
  end
end




