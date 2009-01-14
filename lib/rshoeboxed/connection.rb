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

    # note that result_count can only be 50, 100, or 200

    def get_receipt_call(result_count=50, page_no = 1)
      receipt = Receipt.new

      request = build_receipt_request(result_count, page_no)
      response = post_xml(request)

      puts response.inspect


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
      #      request = Net::HTTP.post_form(URI.parse(API_URL),
      #                                   {'xml'=>CGI.escape(body)})

      request = Net::HTTP::Post.new(API_PATH)
      request.set_form_data({'xml'=>body}, ';')

      # request.body = body
      # request.content_type = 'application/xml'

      result = connection.start  { |http| http.request(request) }

      case result
      when Net::HTTPSuccess, Net::HTTPRedirection
        puts "result"
        # puts result
        puts result.response
        # puts result["location"]

        # OK
      else
        response.error!
        #
        # Failure
        #
        error_msg = result.body
        raise InternalError.new(error_msg) if error_msg =~ /not formatted correctly/
        raise AuthenticationError.new(error_msg) if error_msg =~ /[Aa]uthentication failed/
        raise UnknownSystemError.new(error_msg) if error_msg =~ /does not exist/
        raise InvalidParameterError.new(error_msg) if error_msg =~ /Invalid parameter: (.*)/
        raise ApiAccessNotEnabledError.new(error_msg) if error_msg =~ /API access for this account is not enabled/

        # Raise an exception for unexpected errors
        raise error_msg
      end

      result.body
    end

    def build_receipt_request(result_count, page_no)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        xml.RequesterCredentials do |xml|
          xml.ApiUserToken(@api_key)
          xml.SbxUserToken(@user_token)
        end
        xml.GetReceiptCall do |xml|
          xml.ReceiptFilter do |xml|
            xml.Results(result_count)
            xml.PageNo(page_no)
            xml.DateStart('1900-01-01T00:00:10')
            xml.DateEnd('2100-12-12T00:00:10')
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