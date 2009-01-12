require "cgi"

module RShoeboxed
  class Connection
    API_URL = 'https://www.shoeboxed.com/ws/api.htm'
    
    def self.authentication_url(app_name, app_url, options={})
      url_string = API_URL + "?" + encode_params(
        [[:appname, app_name],
        [:appurl, app_url],
        [:apparams, encode_params(options)],
        [:SignIn, 1]]
      )
      
      url_string
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
  end
end