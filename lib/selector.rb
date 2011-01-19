module Plant
  
  class Selector
    
    class Condition
      
      def initialize wheres, klass
        @wheres = wheres
        @klass = klass
      end
      
      def to_ruby
        @wheres.inject("") do |sql, where|
          copy = where.clone
          copy.gsub!(/\s=\s/, " == ")
          copy.gsub!('"','')
          copy.gsub!(/\slike\s/i,'.match ')
          sql << (sql.blank? ? "" : " and ") + copy
        end
      end
    end
    
    class ArrayCollection
      
      def initialize collection
        @collection = collection
      end
      
      def compare operator, operand
        collection = @collection.dup
        collection.map{|object| object.send(@method)}.any? {|object| object.send(operator, operand) }
      end
 
      def == operand
        compare(:==, operand)
      end
      
      def > operand
        compare(:>, operand)
      end  
      
      def < operand
        compare(:<, operand)
      end
      
      def >= operand
        compare(:>=, operand)
      end
      
      def <= operand
        compare(:<=, operand)
      end
      
      def method_missing method, *args, &block
        @method = method
        self
      end
    end
    
    class Association
      
      def initialize(association)
        @association = association
      end
      
      def method_missing method, *args, &block
        return nil unless @association
        @association.send(method)
        Attribute.new(@association, method)
      end
      
    end
    
    class Attribute
      
      def initialize reference, method=nil
        @reference = reference
        @method = method
      end
      
      def compare operator, operand
        value = @reference.send(@method)
        operand = type_cast(operand, value)
        value.send(operator, operand)
      end
      
      def type_cast operand, value
        case value
         when TrueClass, FalseClass : (operand == 't' || operand == '1')
         else operand
        end
      end
 
      def == operand
        compare(:==, operand)
      end
      
      def > operand
        compare(:>, operand)
      end  
      
      def < operand
        compare(:<, operand)
      end
      
      def >= operand
        compare(:>=, operand)
      end
      
      def <= operand
        compare(:<=, operand)
      end
      
      def match operand
        operand.gsub!(/\%/,'(.*)')
        operand = '^' + operand + '$' 
        @reference.send(@method).match(operand)
      end
      
      def method_missing method, *args, &block
        @method = method
        self
      end
      
    end
    
    def initialize  opt={}
      @wheres = opt[:wheres]
      @plants = opt[:plants]
      @klass = opt[:klass]
    end
 
    def select
      condition = Condition.new(@wheres, @klass)
      Plant::Stubber.stubs_associations_collections
      Plant::Stubber.stubs_attribute_methods
      objects = @plants.select {|object| @binding = binding(); eval("#{condition.to_ruby}")}
      Plant::Stubber.unstubs_associations_collections
      Plant::Stubber.unstubs_attribute_methods
      
      objects
    end

    private
    
    def method_missing method, *args, &block
      case
      when has_one_association?(method) then Association.new(eval("object.#{method.to_s[0..-2]}", @binding))
      when has_many_association?(method) then ArrayCollection.new(eval("object.#{method}", @binding))
      when self_reference?(method) then Attribute.new(eval("object", @binding))
      else Attribute.new(eval("object", @binding), method)
      end
    end
    
    def self_reference? method
      @klass.name.downcase == method.to_s[0..-2]
    end
    
    def has_one_association? method
      @klass.new.respond_to?(method.to_s[0..-2])
    end
    
    def has_many_association? method
      association = @klass.reflect_on_association(method)
      association && association.macro == :has_many
    end
    
  end
end