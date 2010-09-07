require "ostruct"
module Monit
  # The service section from the Monit XML. Inherits from OpenStruct.
  class Service < OpenStruct
    TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }
  end
end
