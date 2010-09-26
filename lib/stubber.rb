module Plant
  module Stubber

    def self.stubs_find klass
      class << klass
        def find *args
          return Plant::Stubber.find_all(self.name.constantize) if args && args.first == :all
          return Plant::Stubber.find(self.name.constantize)
        end
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