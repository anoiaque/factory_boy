begin
  require 'mocha' #must put there even if mocha is not used ... else mocha override these aliasings when it's required in test file.
rescue LoadError
end

module Test
  module Unit
    class TestCase
      alias_method :original_run, :run

      def run(result,&block)
        Plant.destroy
        original_run(result,&block)
        Plant.unstub_find_for_each_class
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
        original_run(result,&block)
        Plant.unstub_find_for_each_class
      end
    end
  end
end