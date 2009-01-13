require 'bigdecimal'
require 'date'
require 'rexml/document'

module RShoeboxed
  class Receipt
    attr_accessor :id, :store, :date, :total, :image_url

    def initialize(xml = nil)
      if xml
        attributes = REXML::Document.new(xml).root.attributes
        # @doc.elements.each("//Receipt") {|receipt| puts receipt.attributes.inspect}
        self.id = attributes["id"]
        self.store = attributes["store"]
        self.date = attributes["date"]
        self.total = attributes["total"]
        self.image_url = attributes["imgurl"]
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
  end
end
