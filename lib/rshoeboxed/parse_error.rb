module RShoeboxed
  class ParseError < StandardError
    attr_accessor :original_error, :xml
  
    def initialize(original_error, xml, msg = nil)
      @original_error = original_error
      @xml = xml
      super(msg)
    end
    
    def to_s
      message = super
      
      "Original Error: #{original_error.to_s}\n" +
      "XML: #{xml.to_s}\n" +
      "Message: #{message}\n"
    end
  end
end
