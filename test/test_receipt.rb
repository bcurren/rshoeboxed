require File.dirname(__FILE__) + '/test_helper.rb'

class TestReceipt < Test::Unit::TestCase
  include RShoeboxed

  def setup
  end
  
  def test_initialize_parse_xml
    response = fixture_xml_content("receipt_info_response")
    receipt = Receipt.new(response)
    
    assert_equal "1", receipt.id
    assert_equal "Morgan Imports", receipt.store
    assert_equal Date.new(2008, 5, 12), receipt.date
    assert_equal BigDecimal.new("1929.00"), receipt.total
    assert_equal "http://www.shoeboxed.com/receipt.jpeg", receipt.image_url
  end
  
  def test_receipt__accessors
    receipt = Receipt.new
    assert receipt
    
    receipt.store = "Macy's"
    assert_equal "Macy's", receipt.store
    
    receipt.id = "1"
    assert_equal "1", receipt.id
    
    receipt.total = '$1,000.19'
    assert_equal BigDecimal.new('1000.19'), receipt.total
    
    receipt.date = '1/1/2001'
    assert_equal Date.parse('1/1/2001'), receipt.date
    
    receipt.image_url = "http://www.example.com/one.image"
    assert_equal "http://www.example.com/one.image", receipt.image_url
  end
end