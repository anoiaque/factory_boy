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
          copy.gsub!("#{@klass.name.downcase}s", "object")
          copy.gsub!(/\s=\s/, " == ")
          copy.gsub!('"','')
          
          sql << (sql.blank? ? "" : " and ") + copy
        end
      end
    end
    
    class ArrayCollection
      
      def initialize array
        @array = array
      end
      
      def compare operator, operand
        collection = @array.dup
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
    
    def initialize  opt={}
      @wheres = opt[:wheres]
      @plants = opt[:plants]
      @klass = opt[:klass]
    end
 
    def select
      condition = Condition.new(@wheres, @klass)
      Plant::Stubber.stubs_associations_collections
      objects = @plants.select {|object| @binding = binding(); eval("#{condition.to_ruby}")}
      Plant::Stubber.unstubs_associations_collections
      objects
    end

    private
    
    def method_missing method, *args, &block
      case
      when has_one_association?(method) then eval("object.#{method.to_s[0..-2]}", @binding)
      when has_many_association?(method) then ArrayCollection.new(eval("object.#{method}", @binding))
      else eval("object.#{method}", @binding)
      end
    end
    
    def has_one_association? method
      @klass.new.respond_to?(method.to_s[0..-2]) #method - 's'
    end
    
    def has_many_association? method
      association = @klass.reflect_on_association(method)
      association && association.macro == :has_many
    end
    
  end
end