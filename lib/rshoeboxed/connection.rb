gem "builder"
require "builder"
require "cgi"
require "net/https"
require 'rexml/document'
require 'logger'
require 'iconv'

module RShoeboxed
  class Error < StandardError; end;
  class UnknownAPICallError < Error; end;
  class InternalError < Error; end;
  class AuthenticationError < Error; end;
  class RestrictedIPError < Error; end;
  class XMLValidationError < Error; end;
  
  class Connection
    attr_accessor :api_key, :user_token
    
    API_SERVER = "www.shoeboxed.com"
    API_PATH = "/ws/api.htm"
    API_URL = "https://" + API_SERVER + API_PATH
    
    @@logger = Logger.new(STDOUT)
    def logger
      @@logger
    end
    
    def self.log_level=(level)
      @@logger.level = level
    end
    self.log_level = Logger::WARN
    
    # Generates a url for you to obtain the user token. This url with take the user to the Shoeboxed authentication
    # page. After the user successfully authenticates, they will be redirected to the app_url with the token and uname
    # as parameters.
    # 
    # app_name - string that contains the name of the app that is calling the API 
    # app_url - url that Shoeboxed will redirect to after a successful authentication
    # app_params - option hash or array of strings containing params that will be passed back to app_url
    def self.authentication_url(app_name, app_url, app_params={})
      API_URL + "?" + encode_params(
      [[:appname, app_name],
      [:appurl, app_url],
      [:apparams, encode_params(app_params)],
      [:SignIn, 1]]
      )
    end
    
    
    # The initialization method takes in two params:
    # api_key - 
    # user_token (generated after validating from the authentication url)
    def initialize(api_key, user_token)
      @api_key = api_key
      @user_token = user_token
    end
    
    def get_receipt_info_call(id)
      request = build_receipt_info_request(id)
      response = post_xml(request)
      
      receipts = Receipt.parse(response)
      receipts ? receipts.first : nil
    end
    
    # Note: the result_count can only be 50, 100, or 200
    def get_receipt_call(start_date, end_date, options = {})
      options = {
        :use_sell_date => false,
        :per_page => 50,
        :current_page => 1
      }.merge(options)
      
      request = build_receipt_request(start_date, end_date, options)
      response = post_xml(request)
      
      receipts = Receipt.parse(response)
      wrap_array_with_pagination(receipts, response, options[:current_page], options[:per_page])
    end
    
    def get_category_call
      request = build_category_request
      response = post_xml(request)
      
      Category.parse(response)
    end
    
  private
    
    def wrap_array_with_pagination(receipts, response, current_page, per_page)
      document = REXML::Document.new(response)
      counts = document.elements.collect("//Receipts") { |element| element.attributes["count"] || 0 }
      
      ListProxy.new(receipts, counts.first, current_page, per_page)
    end
    
    def date_to_s(date)
      my_date = date
      if !date.kind_of?(String)
        my_date = date.strftime("%Y-%m-%dT%H:%M:%S")
      end
      my_date
    end
    
    def self.encode_params(params)
      # If hash, turn to array and give it alpha ordering
      if params.kind_of? Hash
        params = params.to_a
      end
      
      encoded_params = params.collect do |name, value|
        "#{CGI.escape(name.to_s)}=#{CGI.escape(value.to_s)}"
      end
      encoded_params.join("&")
    end
    

    def post_xml(body)
      connection = Net::HTTP.new(API_SERVER, 443)
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(API_PATH)
      request.set_form_data({'xml'=>body})

      result = connection.start  { |http| http.request(request) }

      # Convert to UTF-8, shoeboxed encodes with ISO-8859-1
      result_body = Iconv.conv('UTF-8', 'ISO-8859-1', result.body)

      if logger.debug?
        logger.debug "Request:"
        logger.debug body
        logger.debug "Response:"
        logger.debug result_body
      end

      check_for_api_error(result_body)
    end
    
    def check_for_api_error(body)
      document = REXML::Document.new(body)
      root = document.root
      
      if root && root.name == "Error"
        description = root.attributes["description"]
        
        case root.attributes["code"]
        when "1"
          raise AuthenticationError.new(description)
        when "2"
          raise UnknownAPICallError.new(description)
        when "3"
          raise RestrictedIPError.new(description)
        when "4"
          raise XMLValidationError.new(description)
        when "5"
          raise InternalError.new(description)
        end
      end
      
      body
    end
    
    def build_receipt_request(start_date, end_date, options)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        append_credentials(xml)
        xml.GetReceiptCall do |xml|
          xml.ReceiptFilter do |xml|
            xml.Results(options[:per_page])
            xml.PageNo(options[:current_page])
            xml.DateStart(date_to_s(start_date))
            xml.DateEnd(date_to_s(end_date))
            xml.UseSellDate(options[:use_sell_date])
            xml.Category(options[:category_id]) if options[:category_id]
          end
        end
      end
    end
    
    def build_category_request
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        append_credentials(xml)
        xml.GetCategoryCall
      end
    end
    
    def build_receipt_info_request(id)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        append_credentials(xml)
        xml.GetReceiptInfoCall do |xml|
          xml.ReceiptFilter do |xml|
            xml.ReceiptId(id)
          end
        end
      end
    end
    
    def append_credentials(xml)
      xml.RequesterCredentials do |xml|
        xml.ApiUserToken(@api_key)
        xml.SbxUserToken(@user_token)
      end
    end
  end
end