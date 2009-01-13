require 'bigdecimal'
require 'date'
require 'rexml/document'

module RShoeboxed
  class Receipt
    attr_accessor :id, :store, :date, :total, :image_url
    
    def self.parse(xml)
      document = REXML::Document.new(xml)
      document.elements.collect("//Receipt") do |receipt_element|
        receipt = Receipt.new
        
        receipt.id = receipt_element.attributes["id"]
        receipt.store = receipt_element.attributes["store"]
        receipt.date = receipt_element.attributes["date"]
        receipt.total = receipt_element.attributes["total"]
        receipt.image_url = receipt_element.attributes["imgurl"]
        
        receipt
      end
    end
    
    def initialize
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
  end
end
