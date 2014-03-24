# @TODO: Note that this is entirely untested and not yet implemented.

require "wdm"

module VagrantPlugins
  module GatlingRsync
    class ListenWindows
      def initialize(paths, ignores, latency, logger, callback)
        @paths = paths
        @ignores = ignores
        @latency = latency
        @logger = logger
        @callback = callback
      end

      def run
        @logger.info("Listening via: WDM on Windows.")
        monitor = WDM::Monitor.new
        changes = Queue.new
        @paths.keys.each do |path|
          monitor.watch_recursively(path) { |change| changes << change }
        end
        Thread.new { monitor.run! }

        loop do
          directories = Set.new
          begin
            loop do
              change = Timeout::timeout(@latency) {
                changes.pop
              }
              directories << change.path
            end
          rescue Timeout::Error
            @logger.info("Breaking out of the loop at #{Time.now.to_s}.")
          end

          @logger.info(directories.inspect) unless directories.empty?

          @callback.call(@paths, @ignores, directories) unless directories.empty?
        end
      end
    end
  end
end

