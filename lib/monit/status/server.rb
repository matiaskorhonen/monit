module Monit
  # The server section from the Monit XML
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
end
