module Monit
  # The platform section from the Monit XML
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
end
