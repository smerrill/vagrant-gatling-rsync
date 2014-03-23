require "rb-fsevent"

module VagrantPlugins
  module GatlingRsync
    class ListenOSX
      def initialize(paths, ignores, latency, logger, callback)
        @paths = paths
        @ignores = ignores
        @latency = latency
        @options = {
          # We set this to a small value to ensure that we can coalesce the
          # events together to prevent rsyncing too often under heavy write
          # load.
          :latency => 0.1,
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
              @logger.info("Starting the timeout at #{Time.now.to_s}.")
              change = Timeout::timeout(@latency) {
                changes.pop
              }
              directories << change unless change.nil?
            end
          rescue Timeout::Error
            @logger.info("Breaking out of the loop at #{Time.now.to_s}.")
          end

          @logger.info("Detected changes to #{directories.inspect}.") unless directories.empty?

          @callback.call(@paths, @ignores, directories) unless directories.empty?
        end
      end
    end
  end
end

