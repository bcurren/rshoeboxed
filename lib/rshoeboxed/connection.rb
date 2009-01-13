gem "builder"
require "builder"
require "cgi"
require "net/https"

module RShoeboxed
  class Connection
    attr_accessor :api_key, :user_token

    API_SERVER = "www.shoeboxed.com"
    API_PATH = "/ws/api.htm"
    API_URL = "https://" + API_SERVER + API_PATH


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
    
    def get_receipt_call
      receipt = Receipt.new

      request = build_receipt_request
      response = post_xml(request)

      Receipt.parse(response)
    end

  private

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
      # puts "response"
      # puts API_SERVER
      # puts API_PATH
      # puts body

      connection = Net::HTTP.new(API_SERVER, 443)
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(API_PATH)
      request.body = body
      request.content_type = 'application/xml'

      result = connection.start  { |http| http.request(request) }

      puts "result"
      puts result
      puts result.inspect
      puts result["location"]

      result.body
    end

    def build_receipt_request
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        xml.RequesterCredentials do |xml|
          xml.ApiUserToken(@api_key)
          xml.SbxUserToken(@user_token)
        end
        xml.GetReceiptCall do |xml|
          xml.ReceiptFilter do |xml|
          end
        end
      end
    end

    def build_receipt_info_request(id)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        xml.RequesterCredentials do |xml|
          xml.ApiUserToken(@api_key)
          xml.SbxUserToken(@user_token)
        end
        xml.GetReceiptInfoCall do |xml|
          xml.ReceiptFilter do |xml|
            xml.ReceiptId(id)
          end
        end
      end
    end

  end
end