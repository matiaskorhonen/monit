require "ostruct"
module Monit
  # The service section from the Monit XML. Inherits from OpenStruct.
  class Service < OpenStruct
    TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }

    def initialize(hash = nil, options = {})
      @host ||= options[:host] ||= "localhost"
      @port ||= options[:port] ||= 2812
      @ssl  ||= options[:ssl]  ||= false
      @auth ||= options[:auth] ||= false
      @username = options[:username]
      @password = options[:password]

      hash = rename_service_type(hash) if hash
      super(hash)
    end

		def url path
      url_params = { :host => @host, :port => @port, :path => "/#{path}" }
      @ssl ? URI::HTTPS.build(url_params) : URI::HTTP.build(url_params)
		end

		def start
			return self.do :start
		end

		def stop
			return self.do :stop
		end

		def restart
			return self.do :restart
		end

		def monitor
			return self.do :monitor
		end

		def unmonitor
			return self.do :unmonitor
		end

		def do action
			uri = self.url self.name
			http = Net::HTTP.new(uri.host, uri.port)

      if @ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(uri.request_uri)
			request.body = "action=#{action}"

      if @auth
        request.basic_auth(@username, @password)
      end

      request["User-Agent"] = "Monit Ruby client #{Monit::VERSION}"

      response = http.request(request)

      if response.code == "200"
        return true
      else
        return false
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
