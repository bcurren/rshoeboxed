require 'rexml/document'

module RShoeboxed
  class Category
    attr_accessor :id, :name

    def self.parse(xml)
      document = REXML::Document.new(xml)
      document.elements.collect("//Category") do |category_element|
        category = Category.new
        category.id = category_element.attributes["id"]
        category.name = category_element.attributes["name"]
        category
      end
    end

  end
end
