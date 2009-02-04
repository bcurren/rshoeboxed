require File.dirname(__FILE__) + '/test_helper.rb'
require 'credentials'

class ManualIntegration < Test::Unit::TestCase
  include RShoeboxed
  
  def setup
    # Connection.log_level = Logger::DEBUG
    @conn = Connection.new(API_USER_TOKEN, USER_TOKEN)
  end
  
  def test_get_receipt_call__dont_use_sell_date
    receipts = @conn.get_receipt_call(Date.new(2000, 1, 1), Date.today)
    assert receipts.size > 0
  end
  
  def test_get_receipt_call__use_sell_date
    receipts = @conn.get_receipt_call(Date.new(2000, 1, 1), Date.new(2009, 1, 1), :use_sell_date => true)
    assert receipts.size > 0
  end
  
  def test_get_receipt_info_call
    receipt_id = "313000608"
    
    receipt = @conn.get_receipt_info_call(receipt_id)
    assert_not_nil receipt
    assert_equal receipt_id, receipt.id
  end
  
  def test_get_receipt_info_call
    receipt_id = "313000608"
    
    categories = @conn.get_category_call
    assert categories.size > 0
  end
end