require "ostruct"
module Monit
  # The service section from the Monit XML. Inherits from OpenStruct.
  class Service < OpenStruct
    TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }

    def initialize(hash = nil, options = {})
      @host     ||= options[:host] || "localhost"
      @port     ||= options[:port] || 2812
      @ssl      ||= options[:ssl]  || false
      @auth     ||= options[:auth] || false
      @username = options[:username]
      @password = options[:password]

      hash = rename_service_type(hash) if hash
      super(hash)
    end

    def url(path)
      url_params = { :host => @host, :port => @port, :path => "/#{path}" }
      @ssl ? URI::HTTPS.build(url_params) : URI::HTTP.build(url_params)
    end

    [:start, :stop, :restart, :monitor, :unmonitor].each do |action|
      define_method "#{action}!" do
        self.do action
      end
    end

    def do(action)
      uri = self.url self.name
      http = Net::HTTP.new(uri.host, uri.port)

      if @ssl
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request      = Net::HTTP::Post.new(uri.request_uri)
      request.body = "action=#{action}"

      request.basic_auth(@username, @password) if @auth
      request["User-Agent"] = "Monit Ruby client #{Monit::VERSION}"

      begin
        response = http.request(request)
        !!(response.code =~ /\A2\d\d\z/)
      rescue Errno::ECONNREFUSED => e
        false
      end
    end

    def has_errors?(code = nil, exact = false)
      if code.nil? or code == 0
        self.status.to_i != 0 and self.status_hint.to_i == 0
      elsif exact
        self.status.to_i == code and self.status_hint.to_i == 0
      else
        (self.status.to_i & code) != 0 and (self.status_hint.to_i & code) == 0
      end
    end

    private
    # Renames the Service type from "type" to "service_type" to avoid conflicts
    def rename_service_type(hash)
      hash["service_type"] = hash["type"]
      hash.delete("type")
      hash
    end
  end
end
