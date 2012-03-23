require "ostruct"
module Monit
  # The service section from the Monit XML. Inherits from OpenStruct.
  class Service < OpenStruct
    TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }

    def missing_method action
	    if self.respond_to? action
		    return true
	    else
		    return false
	    end

    end

    def define_monit_action action, options
	instance_eval <<-RUBY
		def #{action}
		      url_params = { :host => '#{options[:host]}', :port => #{options[:port]}, :path => "/\#{self.name}" }
			#{action}_url = #{options[:ssl].to_s} ? URI::HTTPS.build(url_params) : URI::HTTP.build(url_params)
			c = Curl::Easy.new(#{action}_url.to_s) do |curl|
				curl.post_body = "action=#{action.upcase}"
				if #{options[:auth].to_s}
					curl.username = '#{options[:username]}'
					curl.password = '#{options[:password]}'
				end
				curl.headers["Content-Type"] = "application/x-www-form-urlencoded"
			end
			c.perform

			if c.response_code == 200
				#html = c.body_str
				return true
			else
				return false
			end
		end
	RUBY
    end
  end
end
