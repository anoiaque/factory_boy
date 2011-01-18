module Plant
  module Stubber
    @@stubbed = false
    
    def self.stubs
      return if @@stubbed
      stubs_find
      stubs_array
      stubs_where
      stubs_order
      stubs_includes
      stubs_limit
      @@stubbed = true
    end
    
    def self.unstubs
      return unless @@stubbed
      unstubs_where
      unstubs_order
      unstubs_limit
      unstubs_includes
      unstubs_array
      unstubs_find
      @@stubbed = false
    end
  
    def self.stubs_find
      active_record_base_eigenclass = class << ActiveRecord::Base; self end
      
      redefine(active_record_base_eigenclass, :find) do |*args|
        klass = self.name.constantize
        case args.first
          when :first then Plant::Query.find_all(klass).first
          when :last  then Plant::Query.find_all(klass).last
          when :all   then Plant::Query.find_all(klass)
          else Plant::Query.find_by_ids(klass, args)
        end
      end
      
      redefine(active_record_base_eigenclass, :find_by_sql) do |*args|
        Plant::Query.select(self)
      end 

      redefine(active_record_base_eigenclass, :first) do |*args|
        Plant::Query.find_all(self.name.constantize).first
      end 
      
      redefine(active_record_base_eigenclass, :all) do |*args|
        Plant::Query.find_all(self.name.constantize)
      end 
      
      redefine(active_record_base_eigenclass, :last) do |*args|
        Plant::Query.find_all(self.name.constantize).last
      end 
    end
    
    def self.stubs_array
      redefine(Array, :method_missing) do |method, *args, &block|
        case method
        when :order : Plant::Query.order(self, *args)
        when :limit : Plant::Query.limit(self, *args)  
        end
      end
    end
    
    def self.stubs_where
      redefine(ActiveRecord::QueryMethods, :where) do |opts, *rest|
        result = original_where(opts, rest)
        Plant::Query.wheres = result.where_clauses
        result
      end
    end
    
    def self.stubs_order
      redefine(ActiveRecord::QueryMethods, :order) do |*args|
        self.all.order(*args)
      end
    end
    
    def self.stubs_limit
      redefine(ActiveRecord::QueryMethods, :limit) do |*args|
        self.all.limit(*args)
      end
    end
    
    def self.stubs_includes
      redefine(ActiveRecord::QueryMethods, :includes) do |*args|
        self
      end
    end
    
    def self.stubs_associations_collections
      ActiveRecord::Associations::AssociationCollection.send(:alias_method, :original_method_missing, :method_missing)
      ActiveRecord::Associations::AssociationCollection.send(:define_method, :method_missing) do |method, *args, &block|
        eval("@target.#{method}")
      end      
    end
    
    def self.stubs_attribute_methods
      redefine(ActiveRecord::AttributeMethods, :method_missing)
    end
    
    
    def self.unstubs_associations_collections
      undefine(ActiveRecord::Associations::AssociationCollection, :method_missing)
    end
    
    def self.unstubs_attribute_methods
      undefine(ActiveRecord::AttributeMethods, :method_missing)
    end
    
    def self.unstubs_where
      undefine(ActiveRecord::QueryMethods, :where)
    end
    
    def self.unstubs_order
      undefine(ActiveRecord::QueryMethods, :order)
    end
    
    def self.unstubs_limit
      undefine(ActiveRecord::QueryMethods, :limit)
    end
    
    def self.unstubs_includes
      undefine(ActiveRecord::QueryMethods, :includes)
    end
    
    def self.unstubs_array
      undefine(Array, :method_missing)
    end
    
    def self.unstubs_find
      active_record_base_eigenclass = class << ActiveRecord::Base; self end
      
      undefine(active_record_base_eigenclass, :find)
      undefine(active_record_base_eigenclass, :find_by_sql)
      undefine(active_record_base_eigenclass, :first)
      undefine(active_record_base_eigenclass, :last)
      undefine(active_record_base_eigenclass, :all)
    end
    
    private
    
    def self.redefine klass, method, &block
      klass.send(:alias_method, original_method(method), method)
      klass.send(:define_method, method) do |*params|
        instance_exec(*params, &block)
      end
    end
    
    def self.undefine klass, method
      klass.send(:undef_method, method)
      klass.send(:alias_method, method, original_method(method))
    end
    
    def self.original_method method
      ('original_' + method.to_s).to_sym
    end
    
  end
end