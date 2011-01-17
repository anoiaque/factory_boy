module Plant
  module Stubber

    def self.stubs_find
      class << ActiveRecord::Base
        alias_method :original_find, :find
        alias_method :original_find_by_sql, :find_by_sql
        alias_method :orginal_first, :first
        alias_method :orginal_all, :all
        alias_method :orginal_last, :last
        
        def first
          Plant.find_all(self.name.constantize).first
        end
        
        def all
          Plant.find_all(self.name.constantize)
        end
        
        def last
          Plant.find_all(self.name.constantize).last
        end
        
        def find *args
          klass = self.name.constantize
          case args.first
            when :first then Plant.find_all(klass).first
            when :last  then Plant.find_all(klass).last
            when :all   then Plant.find_all(klass)
            else Plant.find_by_ids(klass, args)
          end
        end
        
        def find_by_sql sql
          Plant.select(self)
        end
  
      end
    end

    def self.unstubs_find
      class << ActiveRecord::Base
        undef_method :find
        alias_method :find, :original_find
        
        undef_method :find_by_sql
        alias_method :find_by_sql, :original_find_by_sql
        
        undef_method :first
        alias_method :first, :orginal_first
        
        undef_method :last
        alias_method :last, :orginal_last
        
        undef_method :all
        alias_method :all, :orginal_all
      end
    end
    
    def self.stubs_array
      Array.send(:alias_method, :original_method_missing, :method_missing)
      Array.send(:define_method, :method_missing) do |method, *args, &block|
        case method
        when :order : Plant.order(self, *args)
        end
      end
    end
    
    def self.stubs_where
      ActiveRecord::QueryMethods.send(:alias_method, :original_where, :where)
      ActiveRecord::QueryMethods.send(:define_method, :where) do |opts, *rest|
        result = original_where(opts, rest)
        Plant.wheres = result.where_clauses
        result
      end
    end
    
    def self.stubs_includes
      ActiveRecord::QueryMethods.send(:alias_method, :original_includes, :includes)
      ActiveRecord::QueryMethods.send(:define_method, :includes) do |*args|
        self
      end
    end
    
    def self.stubs_associations_collections
      ActiveRecord::Associations::AssociationCollection.send(:alias_method, :original_method_missing, :method_missing)
      ActiveRecord::Associations::AssociationCollection.send(:define_method, :method_missing) do |method, *args, &block|
        eval("@target.#{method}")
      end      
    end
    
    def self.unstubs_associations_collections
      ActiveRecord::Associations::AssociationCollection.send(:undef_method, :method_missing)
      ActiveRecord::Associations::AssociationCollection.send(:alias_method, :method_missing, :original_method_missing)
    end
    
    def self.stubs_attribute_methods
      ActiveRecord::AttributeMethods.send(:alias_method, :original_method_missing, :method_missing)
      ActiveRecord::AttributeMethods.send(:define_method, :method_missing) do |method, *args, &block|
        
      end      
    end
    
    def self.unstubs_attribute_methods
      ActiveRecord::AttributeMethods.send(:undef_method, :method_missing)
      ActiveRecord::AttributeMethods.send(:alias_method, :method_missing, :original_method_missing)
    end
    
    def self.unstubs_where
      ActiveRecord::QueryMethods.send(:undef_method, :where)
      ActiveRecord::QueryMethods.send(:alias_method, :where, :original_where)
    end
    
    def self.unstubs_includes
      ActiveRecord::QueryMethods.send(:undef_method, :includes)
      ActiveRecord::QueryMethods.send(:alias_method, :includes, :original_includes)
    end
    
    def self.unstubs_array
      Array.send(:undef_method, :method_missing)
      Array.send(:alias_method, :method_missing, :original_method_missing)
    end
    
  end
end