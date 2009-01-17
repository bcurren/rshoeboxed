require File.dirname(__FILE__) + '/test_helper.rb'

class TestConnection < Test::Unit::TestCase
  include RShoeboxed
  
  def test_pages
    proxy = ListProxy.new([], 39, 2, 20)
    assert_equal 39, proxy.total
    assert_equal 2, proxy.current_page
    assert_equal 20, proxy.per_page
    assert_equal 2, proxy.pages
    
    proxy = ListProxy.new([], 40, 2, 20)
    assert_equal 2, proxy.pages
    
    proxy = ListProxy.new([], 0, 1, 20)
    assert_equal 0, proxy.pages
  end
end
