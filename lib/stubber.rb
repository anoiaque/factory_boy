module Plant
  module Stubber

    def self.stubs_find klass
      class << klass
        alias_method :original_find, :find
        
        def find *args
          case args.first
            when :first then Plant::Stubber.find_all(self.name.constantize).first
            when :last  then Plant::Stubber.find_all(self.name.constantize).last
            when :all   then Plant::Stubber.find_all(self.name.constantize)
            else Plant::Stubber.find(self.name.constantize)
          end
        end
      end
    end

    def self.unstubs_find_for klass
      class << klass
        undef_method :find
        alias_method :find, :original_find
      end
    end
    
    def self.find_all klass
      Plant.all[klass] || []
    end

    def self.find klass
      return nil unless Plant.all[klass]
      Plant.all[klass].size == 1 ?  Plant.all[klass].first : Plant.all[klass]
    end

  end
end