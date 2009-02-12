require 'bigdecimal'
require 'date'
require 'rexml/document'

module RShoeboxed
  class Receipt
    attr_accessor :id, :store, :image_url, :categories
    attr_reader :date, :total
    
    def self.parse(xml)
      document = REXML::Document.new(xml)
      document.elements.collect("//Receipt") do |receipt_element|
        receipt = Receipt.new
        
        receipt.id = receipt_element.attributes["id"]
        receipt.store = receipt_element.attributes["store"]
        receipt.date = receipt_element.attributes["date"]
        receipt.total = receipt_element.attributes["total"]
        receipt.image_url = receipt_element.attributes["imgurl"]
        
        # Get the categories elements and have Category parse them
        category_element = receipt_element.elements["Categories"]
        receipt.categories = category_element ? Category.parse(category_element.to_s) : []
        
        receipt
      end
    end
    
    def total=(total)
      total.gsub!(/[^\d|.]/, "") if total.is_a?(String)
      total = BigDecimal.new(total) unless total.is_a?(BigDecimal)
      
      @total = total
    end
    
    def date=(date)
      date = Date.parse(date) if date.is_a?(String)
      @date = date
    end
    
    def ==(receipt)
      self.id == receipt.id && self.store == receipt.store && self.image_url == receipt.image_url &&
        self.categories == receipt.categories && self.date == receipt.date && self.total == receipt.total
    end
  end
end
