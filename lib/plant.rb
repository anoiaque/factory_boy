require 'stubber'
require 'selector'
require 'setup'
require 'query'
require 'reflection'

module Plant

  @@plants = {}
  @@pool = {}
  @@map = {}
  @@sequences = {}
 @@id = 0

  def self.define symbol, args={}
    klass = args[:class] || symbol.to_s.camelize.constantize
    definition = klass.new
    yield definition if block_given?
    add_plant(klass, definition)
    add_plant(symbol, definition) if args[:class]
    Plant::Reflection.reflect(klass)
    Plant::Stubber.stubs
  end

  def self.add_plant klass, instance
    @@plants[klass] = instance
  end

  def self.plants
    @@plants
  end
  
  def self.all
    @@pool
  end

  def self.reload
    load "#{RAILS_ROOT}/test/plants.rb" if Plant.plants.empty?
  end

  def self.pool symbol
    definition = plants[symbol] || plants[symbol.to_s.camelize.constantize]
    object = Plant::Reflection.clone(definition,@@id += 1)
    yield  object if block_given?
    @@pool[definition.class] ||= []
    @@pool[definition.class] << object
    object
  end

  def self.destroy
    @@pool = {}
    @@plants = {}
    @@map = {}
    @@sequences = {}
   @@id = 0
  end

  def self.sequence symbol, &proc
    @@sequences[symbol] = {:lambda => proc, :index => 0}
  end

  def self.next symbol
    @@sequences[symbol][:lambda].call(@@sequences[symbol][:index] += 1)
  end
  
  def self.set_foreign_keys object, association, value
    fk_setter = lambda {|value| value.send(Plant::Reflection.foreign_key(object, association) + '=', object.id)}
    
    case
    when Plant::Reflection.has_many_association?(object.class, association) then value.each {|v| fk_setter.call(v)}
    when value && Plant::Reflection.has_one_association?(object.class, association) then fk_setter.call(value)
    end
  end

end

def Plant symbol, args={}
  Plant.reload
  Plant.pool(symbol) do |instance|
    args.each {|key, value| Plant.set_foreign_keys(instance, key, value); instance.send(key.to_s + '=', value)}
  end
end
