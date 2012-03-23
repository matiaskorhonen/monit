require "ostruct"
module Monit
  # The service section from the Monit XML. Inherits from OpenStruct.
  class Service < OpenStruct
    TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }

    def initialize(hash = nil)
      hash = rename_service_type(hash) if hash
      super(hash)
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
