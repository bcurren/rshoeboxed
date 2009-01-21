$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'rshoeboxed/receipt'
require 'rshoeboxed/category'
require 'rshoeboxed/connection'
require 'rshoeboxed/list_proxy'

module RShoeboxed
  VERSION = '0.0.1'
end