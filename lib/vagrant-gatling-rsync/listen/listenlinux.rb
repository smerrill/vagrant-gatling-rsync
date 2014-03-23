require "rb-inotify"

module VagrantPlugins
  module GatlingRsync
    class ListenLinux
      def initialize(paths, ignores, latency, logger, callback)
        @paths = paths
        @ignores = ignores
        @latency = latency
        @logger = logger
        @callback = callback
      end

      def run
        @logger.info("Listening via: rb-inotify on Linux.")

        notifier = INotify::Notifier.new
        @paths.keys.each do |path|
          notifier.watch(path, :modify, :create, :delete, :recursive) {}
        end

        while true do
          directories = Set.new
          begin
            while true do
              events = []
              events = Timeout::timeout(@latency) {
                notifier.read_events
              }
              events.each { |e| directories << e.absolute_name }
            end
          rescue Timeout::Error
            puts "Breaking out of the loop at #{Time.now.to_s}"
          end

          @logger.info("Detected changes to #{directories.inspect}.")

          @callback.call(@paths, @ignores, directories) if directories.size
        end
      end
    end
  end
end

