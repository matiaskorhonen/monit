require "curb"
require "uri"
require "crack/xml"
require "ostruct"

module Monit
  class Status
    attr_reader :url, :hash, :xml, :server, :platform, :services
    attr_accessor :username, :auth
    attr_writer :password
    
    def initialize(options = {})
      options[:host] ||= "localhost"
      options[:port] ||= 2812
      options[:ssl] ||= false
      options[:auth] ||= false
      options[:username] ||= ""
      options[:password] ||= ""
      
      url_params = { :host => options[:host], :port => options[:port], :path => "/_status", :query => "format=xml" }
      
      @url = options[:ssl] ? URI::HTTPS.build(url_params) : URI::HTTP.build(url_params)
      @username = options[:username]
      @password = options[:password]
      @auth = options[:auth]
      @services = []
    end
    
    def get
      c = Curl::Easy.new(@url.to_s) do |curl|
        if @auth
          curl.password = @password
          curl.username = @username
        end
        curl.headers["User-Agent"] = "Monit Ruby client #{Monit::VERSION}"
      end
      c.perform
      
      if c.response_code == 200
        @xml = c.body_str
        @hash = Crack::XML.parse(@xml)
        self.parse(@hash)
      end
    end
    
    def parse(hash)
      @server = Server.new(hash["monit"]["server"])
      @platform = Platform.new(hash["monit"]["platform"])
      if hash["monit"]["service"].is_a? Array
        @services = hash["monit"]["service"].map do |service|
          Service.new(service)
        end
      else
        @services = [Service.new(hash["monit"]["service"])]
      end
    end
  end
  
  class Server
      attr_reader :id, :incarnation, :version, :uptime, :poll, :startdelay, :localhostname, :controlfile, :httpd
      
      def initialize(options = {})
        @id = options["id"]
        @incarnation = options["incarnation"]
        @version = options["version"]
        @uptime = options["uptime"].to_i
        @poll = options["poll"].to_i
        @startdelay = options["startdelay"].to_i
        @localhostname = options["localhostname"]
        @controlfile = options["controlfile"]
        @httpd = options["httpd"].is_a?(HTTPD) ? options["httpd"] : HTTPD.new(options["httpd"])
      end
  end
  
  class HTTPD
    attr_reader :address, :port, :ssl
        
    def initialize(options = {})
      @address = options[address]
      @port = options["port"].to_i
      @ssl = options["ssl"] == "1" ? true : false
    end
  end
  
  class Platform
    attr_reader :name, :release, :version, :machine, :cpu, :memory
    
    def initialize(options = {})
      @name = options["name"]
      @release = options["release"]
      @version = options["version"]
      @machine = options["machine"]
      @cpu = options["cpu"].to_i
      @memory = options["memory"].to_i
    end
  end
  
  class Service < OpenStruct
    TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }
  end
end
