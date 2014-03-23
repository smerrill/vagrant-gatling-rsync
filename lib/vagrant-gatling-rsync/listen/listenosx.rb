require "rb-fsevent"

module VagrantPlugins
  module GatlingRsync
    class ListenOSX
      def initialize(paths, ignores, latency, logger, callback)
        @paths = paths
        @ignores = ignores
        @options = {
          :latency => latency,
          :no_defer => false,
        }
        @logger = logger
        @callback = callback
      end

      def run
        @logger.info("Listening via: rb-fsevent on Mac OS X.")

        fsevent = FSEvent.new
        fsevent.watch @paths.keys, @options do |directories|
          @callback.call(@paths, @ignores, directories)
        end
        fsevent.run
      end
    end
  end
end

