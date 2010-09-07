require "curb"
require "uri"
require "crack/xml"

# A Ruby interface for Monit
module Monit
  # The +Status+ class is used to get data from the Monit instance. You should not
  # need to manually instantiate any of the other classes.
  class Status
    attr_reader :url, :hash, :xml, :server, :platform, :services
    attr_accessor :username, :auth, :host, :port, :ssl, :auth, :username
    attr_writer :password
    
    # Create a new instance of the status class with the given options
    # 
    # <b>Options:</b>
    # * +host+ - the host for monit, defaults to +localhost+
    # * +port+ - the Monit port, defaults to +2812+
    # * +ssl+ - should we use SSL for the connection to Monit (default: false)
    # * +auth+ - should authentication be used, defaults to false
    # * +username+ - username for authentication
    # * +password+ - password for authentication
    def initialize(options = {})
      @host ||= options[:host] ||= "localhost"
      @port ||= options[:port] ||= 2812
      @ssl  ||= options[:ssl]  ||= false
      @auth ||= options[:auth] ||= false
      @username = options[:username]
      @password = options[:password]
      @services = []
    end
    
    # Construct the URL
    def url
      url_params = { :host => @host, :port => @port, :path => "/_status", :query => "format=xml" }
      @ssl ? URI::HTTPS.build(url_params) : URI::HTTP.build(url_params)
    end
    
    # Get the status from Monit.
    def get
      c = Curl::Easy.new(self.url.to_s) do |curl|
        if @auth
          curl.password = @password
          curl.username = @username
        end
        curl.headers["User-Agent"] = "Monit Ruby client #{Monit::VERSION}"
      end
      c.perform
      
      if c.response_code == 200
        @xml = c.body_str
        return self.parse(@xml)
      else
        return false
      end
    end
    
    # Parse the XML from Monit into a hash and into a Ruby representation.
    def parse(xml)
      @hash = Crack::XML.parse(xml)
      @server = Server.new(@hash["monit"]["server"])
      @platform = Platform.new(@hash["monit"]["platform"])
      if @hash["monit"]["service"].is_a? Array
        @services = @hash["monit"]["service"].map do |service|
          Service.new(service)
        end
      else
        @services = [Service.new(@hash["monit"]["service"])]
      end
      true
    rescue
      false
    end
  end
end
