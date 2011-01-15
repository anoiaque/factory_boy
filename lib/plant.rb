require 'stubber'
require 'selector'
require 'setup'

module Plant

  @@plants = {}
  @@pool = {}
  @@map = {}
  @@sequences = {}
  @@stubbed = []
  @@stubbed_where = false
  
  @@wheres = nil
  
  def self.define symbol, args={}
    klass = args[:class] || symbol.to_s.camelize.constantize
    instance = klass.new
    yield instance if block_given?
    add_plant(klass, instance)
    add_plant(symbol, instance) if args[:class]
    stubs(instance.class)
  end
  
  def self.stubs klass
    if (!@@stubbed_where) then Plant::Stubber.stubs_where and  @@stubbed_where = true end
    unless @@stubbed.include?(klass)
      Plant::Stubber.stubs_find(klass)
      @@stubbed << klass
    end
  end
  
  def self.wheres= wheres
    @@wheres = wheres
  end
  
  def self.wheres
    @@wheres
  end
  
  def self.unstub_find_for_each_class
    @@stubbed.each {|klass| Plant::Stubber.unstubs_find_for(klass)}
    @@stubbed = []
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
    @@stubbed = []
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

  def self.find klass
    return nil unless Plant.all[klass]
    Plant.all[klass].size == 1 ?  Plant.all[klass].first : Plant.all[klass]
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




