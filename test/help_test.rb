Object.const_set("RAILS_ROOT", File.join(File.dirname(__FILE__), '../') )

require 'test/unit'
require 'plant'
require 'models/adress'
require 'models/user'
require 'models/profile'
require 'models/customer'

require 'mocha'