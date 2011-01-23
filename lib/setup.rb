# begin
#   require 'mocha' #must put there even if mocha is not used ... else mocha override these aliasings when it's required in test file.
# rescue LoadError
# end

module Plant
  module Run
    def run(result,&block)
      Plant.destroy
      original_run(result,&block)
      Plant::Stubber.unstubs
    end
  end
end

if defined?(ActiveSupport::TestCase)
  require 'active_support/test_case' #fix constant not found Test when ran as gem under rails 3 app 
  module ActiveSupport
    class TestCase < ::Test::Unit::TestCase
      alias_method :original_run, :run
      include Plant::Run
    end
  end
end
