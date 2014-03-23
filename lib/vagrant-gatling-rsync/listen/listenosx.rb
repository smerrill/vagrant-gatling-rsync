require "rb-fsevent"

module VagrantPlugins
  module GatlingRsync
    class ListenOSX
      def initialize(paths, ignores, latency, logger, callback)
        @paths = paths
        @ignores = ignores
        @latency = latency
        @options = {
          :latency => latency,
          :no_defer => false,
        }
        @logger = logger
        @callback = callback
      end

      def run
        @logger.info("Listening via: rb-fsevent on Mac OS X.")
        changes = Queue.new

        fsevent = FSEvent.new
        fsevent.watch @paths.keys, @options do |directories|
          directories.each { |d| changes << d }
        end
        Thread.new { fsevent.run }

        while true do
          directories = Set.new
          begin
            while true do
              puts "Starting the timeout at #{Time.now.to_s}."
              change = Timeout::timeout(@latency) {
                a = changes.pop
                a
              }
              p change
              directories << change unless change.nil?
            end
          rescue Timeout::Error => e
            p e.backtrace
            puts "Breaking out of the loop at #{Time.now.to_s}."
            @logger.info("Breaking out of the loop at #{Time.now.to_s}.")
          end

          @logger.info("Detected changes to #{directories.inspect}.")

          @callback.call(@paths, @ignores, directories) if directories.size
        end
      end
    end
  end
end

