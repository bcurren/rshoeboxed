require File.dirname(__FILE__) + '/test_helper.rb'

class TestConnection < Test::Unit::TestCase
  include RShoeboxed
  
  def setup
  end
  
  def test_authenticate__connection_failures
    assert true
  end
  
  def test_authentication_url__success_with_options
    assert_equal "https://www.shoeboxed.com/ws/api.htm?appname=Bootstrap&appurl=http%3A%2F%2Fexample.com&apparams=test%3D1%26test2%3D1&SignIn=1", 
      Connection.authentication_url("Bootstrap", "http://example.com", [[:test, 1], [:test2, 1]])
  end
  
  
  def test_authentication_url__success_no_options
    assert_equal "https://www.shoeboxed.com/ws/api.htm?appname=Bootstrap&appurl=http%3A%2F%2Fexample.com&apparams=&SignIn=1", 
      Connection.authentication_url("Bootstrap", "http://example.com")
  end
end
