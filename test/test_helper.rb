require File.dirname(__FILE__) + '/../lib/rshoeboxed'

require 'stringio'
require 'test/unit'

gem 'mocha'
require 'mocha'

class Test::Unit::TestCase
  def fixture_xml_content(file_name)
    # Quick way to remove white space and newlines from xml. Makes it easier to compare in tests
    open(File.join(fixture_dir, "#{file_name}.xml"), "r").readlines.inject("") do |contents, line|
      contents + line.strip
    end
  end
  
  def fixture_dir
    File.join(File.dirname(__FILE__), "fixtures")
  end
end
