require File.dirname(__FILE__) + '/test_helper.rb'

class TestReceipt < Test::Unit::TestCase
  include RShoeboxed

  def setup
    @category1 = Category.new
    @category1.id = "23423342"
    @category1.name = "Meals / Entertainment"
    
    @category2 = Category.new
    @category2.id = "9121023"
    @category2.name = "General Retail"

    @category3 = Category.new
    @category3.id = "18222392"
    @category3.name = "Fuel"
  end
  
  def test_initialize_parse_xml
    response = fixture_xml_content("receipt_info_response")
    receipts = Receipt.parse(response)
    assert_equal 1, receipts.size
    
    receipt = receipts.first
    assert_equal "139595947", receipt.id
    assert_equal "Morgan Imports", receipt.store
    assert_equal Date.new(2008, 5, 12), receipt.sell_date
    assert_equal Date.new(2008, 7, 10), receipt.created_date
    assert_equal Date.new(2008, 7, 12), receipt.modified_date
    assert_equal BigDecimal.new("1929.00"), receipt.converted_total
    assert_equal "USD", receipt.account_currency
    assert_equal "http://www.shoeboxed.com/receipt.jpeg?rid=139595947&code=1b106d61cbfa5078f53050e2f3bc315f", receipt.image_url
    assert_equal [@category1, @category2, @category3], receipt.categories
  end
  
  def test_receipt__accessors
    receipt = Receipt.new
    assert receipt
    
    receipt.store = "Macy's"
    assert_equal "Macy's", receipt.store
    
    receipt.id = "1"
    assert_equal "1", receipt.id
   
    receipt.converted_total = '$1,000.19'
    assert_equal BigDecimal.new('1000.19'), receipt.converted_total
    
    receipt.account_currency = "USD"
    assert_equal "USD", receipt.account_currency
    
    receipt.created_date = '1/2/2001'
    assert_equal Date.parse('1/2/2001'), receipt.created_date
    
    receipt.modified_date = '1/3/2001'
    assert_equal Date.parse('1/3/2001'), receipt.modified_date
    
    receipt.image_url = "http://www.example.com/one.image"
    assert_equal "http://www.example.com/one.image", receipt.image_url
    
    receipt.categories = [@category1]
    assert_equal [@category1], receipt.categories
  end

  def test_equal
    # lame test but at least execute the code
    assert_equal Receipt.new, Receipt.new
  end
end
