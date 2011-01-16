require 'rubygems'
require 'rails/all'
require 'active_record'
require 'rake'
require File.join(File.dirname(__FILE__), 'databases.rake.rb')
ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => "db/test.sqlite3"
  )
ENV['SCHEMA']= File.join(File.dirname(__FILE__), 'db/schema.rb')

