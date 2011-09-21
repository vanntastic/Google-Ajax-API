require 'rubygems'
Dir.glob("#{File.dirname(__FILE__) + '/../lib'}/*.rb").each {|f| require(f)}
require 'test/unit'
