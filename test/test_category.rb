require File.dirname(__FILE__) + '/test_helper.rb'

class TestCategory < Test::Unit::TestCase
  include RShoeboxed

  def setup
  end
  
  def test_initialize_parse_xml
     response = fixture_xml_content("category_response")
     categories = Category.parse(response)
     assert_equal 3, categories.size
     
     categories.each_with_index do |category, i|
       category_id = (i+1).to_s
       assert_equal category_id, category.id
       assert_equal "Category #{category_id}", category.name
     end
   end
  
  def test_category__accessors
    category = Category.new
    assert category
    
    category.name = "Category 1"
    assert_equal "Category 1", category.name
    
    category.id = "1"
    assert_equal "1", category.id    
  end
end