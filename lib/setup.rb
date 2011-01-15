begin
  require 'mocha' #must put there even if mocha is not used ... else mocha override these aliasings when it's required in test file.
rescue LoadError
end

module Plant
 module Run
  def run(result,&block)
    Plant.destroy
    original_run(result,&block)
    Plant.unstub_find_for_each_class
  end
 end  
end

if defined?(ActiveSupport::TestCase)
  module ActiveSupport
    class TestCase < ::Test::Unit::TestCase
        alias_method :original_run, :run
        include Plant::Run
    end
  end
end  
