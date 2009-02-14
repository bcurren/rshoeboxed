require 'bigdecimal'
require 'date'
require 'rexml/document'

module RShoeboxed
  class Receipt
    attr_accessor :id, :store, :image_url, :categories
    attr_reader :sell_date, :created_date, :modified_date, :total
    
    def self.parse(xml)
      document = REXML::Document.new(xml)
      document.elements.collect("//Receipt") do |receipt_element|
        receipt = Receipt.new
        begin
          receipt.id = receipt_element.attributes["id"]
          receipt.store = receipt_element.attributes["store"]
          receipt.sell_date = receipt_element.attributes["selldate"]
          receipt.created_date = receipt_element.attributes["createdDate"]
          receipt.modified_date = receipt_element.attributes["modifiedDate"]
          receipt.total = receipt_element.attributes["total"]
          receipt.image_url = receipt_element.attributes["imgurl"]
          
          # Get the categories elements and have Category parse them
          category_element = receipt_element.elements["Categories"]
          receipt.categories = category_element ? Category.parse(category_element.to_s) : []
        rescue => e
          raise RShoeboxed::ParseError.new(e, receipt_element.to_s, "Error parsing receipt.")
        end
        receipt
      end
    end
    
    def total=(total)
      total.gsub!(/[^\d|.]/, "") if total.is_a?(String)
      total = BigDecimal.new(total) unless total.is_a?(BigDecimal)
      
      @total = total
    end
    
    def sell_date=(date)
      date = Date.parse(date) if date.is_a?(String)
      @sell_date = date
    end
    
    def created_date=(date)
      date = Date.parse(date) if date.is_a?(String)
      @created_date = date
    end
    
    def modified_date=(date)
      date = Date.parse(date) if date.is_a?(String)
      @modified_date = date
    end
    
    def ==(receipt)
      self.id == receipt.id && self.store == receipt.store && self.image_url == receipt.image_url &&
        self.categories == receipt.categories && self.sell_date == receipt.sell_date && 
        self.modified_date == receipt.modified_date && self.created_date == receipt.created_date &&
        self.total == receipt.total
    end
  end
end
