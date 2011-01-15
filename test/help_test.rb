Object.const_set("RAILS_ROOT", File.join(File.dirname(__FILE__), '../') )

require 'rubygems'
require 'test/unit'
gem 'activerecord', version='3.0.1'
require 'active_record'

require 'app/models/address'
require 'app/models/user'
require 'app/models/profile'
require 'app/models/customer'

require 'mocha'

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => File.join(File.dirname(__FILE__), "db/development.sqlite3")
)