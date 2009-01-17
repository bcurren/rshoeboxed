module RShoeboxed
  class ListProxy
    attr_reader :current_page, :per_page, :total
  
    def initialize(array, total, current_page, per_page)
      @array = array
    
      @total = total.to_i
      @current_page = current_page.to_i
      @per_page = per_page.to_i
    end
  
    def pages
      pages = total / per_page
      if total % per_page != 0
        pages += 1
      end
      pages
    end
  
    def method_missing(method, *args, &block)
      @array.send(method, *args, &block)
    end
  end
end
