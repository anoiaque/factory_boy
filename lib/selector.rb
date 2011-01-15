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
 
      def == operand
        collection = @array.dup
        collection.map{|object| object.send(@method)}.any? {|object| object == operand }
      end
      
      def > operand
        collection = @array.dup
        collection.map{|object| object.send(@method)}.any? {|object| object > operand }
      end
      
      def < operand
        collection = @array.dup
        collection.map{|object| object.send(@method)}.any? {|object| object < operand }
      end
      
      def >= operand
        collection = @array.dup
        collection.map{|object| object.send(@method)}.any? {|object| object >= operand }
      end
      
      def <= operand
        collection = @array.dup
        collection.map{|object| object.send(@method)}.any? {|object| object <= operand }
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
      stubs_associations_collections_method_missing()
      res = @plants.select {|object| @binding = binding(); eval("#{condition.to_ruby}")}
      unstubs_associations_collections_method_missing
      res
    end

    def method_missing method, *args, &block
      
      if (@klass.new.respond_to?(method.to_s[0..-2]))
        return eval("object.#{method.to_s[0..-2]}", @binding)
      end
      
      association = @klass.reflect_on_association(method)
    
      if (association && association.macro == :has_many)
        return ArrayCollection.new(eval("object.#{method}", @binding))
      end

      eval("object.#{method}", @binding)
    end
    
    def stubs_associations_collections_method_missing
      ActiveRecord::Associations::AssociationCollection.send(:alias_method, :original_method_missing, :method_missing)
      ActiveRecord::Associations::AssociationCollection.send(:define_method, :method_missing) do |method, *args, &block|
        eval("@target.#{method}", @binding)
      end      
    end
    
    def unstubs_associations_collections_method_missing
      ActiveRecord::Associations::AssociationCollection.send(:undef_method, :method_missing)
      ActiveRecord::Associations::AssociationCollection.send(:alias_method, :method_missing, :original_method_missing)
    end
    
  end
end