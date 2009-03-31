$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'rshoeboxed/receipt'
require 'rshoeboxed/category'
require 'rshoeboxed/connection'
require 'rshoeboxed/list_proxy'
require 'rshoeboxed/parse_error'

module RShoeboxed
  VERSION = '0.0.5'
end
