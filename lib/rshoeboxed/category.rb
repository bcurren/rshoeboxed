require 'rexml/document'

module RShoeboxed
  class Category
    attr_accessor :id, :name

    def self.parse(xml)
      document = REXML::Document.new(xml)
      document.elements.collect("//Category") do |category_element|
        category = Category.new
        begin
          category.id = category_element.attributes["id"]
          category.name = category_element.attributes["name"]
        rescue => e
          raise RShoeboxed::ParseError.new(e, category_element.to_s, "Error parsing category.")
        end
        category
      end
    end
    
    def ==(category)
      self.id == category.id && self.name == category.name
    end

  end
end
