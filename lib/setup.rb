require 'mocha' #must put there even if mocha is not used ... else mocha override it when it's required in test file.

module Test
  module Unit
    class TestCase
      alias_method :original_run, :run
      
      def run(result,&block)
        Plant.destroy
        Plant.reload
        original_run(result,&block)
      end
    end
  end
end

if defined?(ActiveSupport::TestCase)
  module ActiveSupport
    class TestCase
      alias_method :original_run, :run
    
      def run(result,&block)
        Plant.destroy
        Plant.reload
        original_run(result,&block)
      end
    end
  end
end