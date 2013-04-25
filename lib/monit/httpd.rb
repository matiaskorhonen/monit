module Monit
  # The HTTPD section from the Monit XML
  class HTTPD
    attr_reader :address, :port, :ssl

    def initialize(options = {})
      @address = options["address"]
      @port    = options["port"]
      @ssl     = options["ssl"] == "1" ? true : false
    end
  end
end
