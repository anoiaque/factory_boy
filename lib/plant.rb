require 'rubygems'
require 'active_support/inflector'

module Plant
  
  @@pool = {}
  
  def self.define klass_symbol
    klass = klass_symbol.to_s.camelize.constantize
    instance = klass.new
    yield instance if block_given?
    pool klass, instance
    stubs_find(klass)
    instance
  end
  
  def test_setup
    ObjectSpace.each_object{|object| p object.class if object.class.name =~ /.*BoyTest$/}
  end
  
  def self.pool klass, instance
    @@pool[klass] ||= []  
    @@pool[klass] << instance
  end
  
  def self.destroy_all
    @@pool = {}
  end
  
  def self.get_pool klass, all=false
    return result @@pool[klass] unless all
    @@pool[klass]
  end
  
  private
  
  def self.stubs_find klass
    class << klass
      def find *args
        return Plant.get_pool(self.name.constantize, true) if args && args.first == :all
        return Plant.get_pool(self.name.constantize)
      end
    end
  end
  
  def self.result data
    return nil if data.empty?
    return data.first if data.size == 1
    data
  end

end