#require "crack/xml"
require "active_support/json"
require "active_support/xml_mini"
require "active_support/core_ext/hash/conversions"
require "net/http"
require "net/https"
require "uri"

# A Ruby interface for Monit
module Monit
  # The +Status+ class is used to get data from the Monit instance. You should not
  # need to manually instantiate any of the other classes.
  class Status
    ::ActiveSupport::XmlMini.backend = "Nokogiri"

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
      uri = self.url
      http = Net::HTTP.new(uri.host, uri.port)

      if @ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Get.new(uri.request_uri)

      if @auth
        request.basic_auth(@username, @password)
      end

      request["User-Agent"] = "Monit Ruby client #{Monit::VERSION}"

      response = http.request(request)

      if response.code == "200"
        @xml = response.body
        return self.parse(@xml)
      else
        return false
      end
    end

    # Parse the XML from Monit into a hash and into a Ruby representation.
    def parse(xml)
      @hash = Hash.from_xml(xml)
      @server = Server.new(@hash["monit"]["server"])
      @platform = Platform.new(@hash["monit"]["platform"])

			options = { 
				:host => @host, 
				:port => @port, 
				:ssl => @ssl, 
				:auth => @auth, 
				:username => @username, 
				:password => @password }

      if @hash["monit"]["service"].is_a? Array
        @services = @hash["monit"]["service"].map do |service|
          Service.new(service, options)
        end
      else
        @services = [Service.new(@hash["monit"]["service"], options)]
      end
      true
    rescue
      false
    end
  end
end
