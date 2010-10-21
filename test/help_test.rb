Object.const_set("RAILS_ROOT", File.join(File.dirname(__FILE__), '../') )

require 'rubygems'
require 'test/unit'
require 'models/adress'
require 'models/user'
require 'models/profile'
require 'models/customer'

require 'mocha'