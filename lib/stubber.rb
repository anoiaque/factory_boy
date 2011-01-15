module Plant
  module Stubber

    def self.stubs_find klass
      class << klass
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
          case args.first
            when :first then Plant.find_all(self.name.constantize).first
            when :last  then Plant.find_all(self.name.constantize).last
            when :all   then Plant.find_all(self.name.constantize)
            else Plant.find(self.name.constantize)
          end
        end
        
        def find_by_sql sql
          Plant.select(self)
        end
  
      end
    end

    def self.unstubs_find_for klass
      class << klass
        # undef_method :find
        #  alias_method :find, :original_find
      end
    end
    
    def self.stubs_where
      
      ActiveRecord::QueryMethods.send(:alias_method, :original_where, :where)
      ActiveRecord::QueryMethods.send(:define_method, :where) do |opts, *rest|
        result = original_where(opts, rest)
        Plant.wheres = result.where_clauses
        result
      end
      
      self.stubs_includes #TODO :move
    end
    
    def self.stubs_includes
      ActiveRecord::QueryMethods.send(:alias_method, :original_includes, :includes)
      ActiveRecord::QueryMethods.send(:define_method, :includes) do |*args|
        self
      end
    end
    

  end
end