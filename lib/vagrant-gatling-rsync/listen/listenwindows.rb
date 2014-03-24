# @TODO: Note that this is entirely untested and not yet implemented.

require "timeout"
require "thread"

paths = {"/path/to/a/directory" => {}}
latency = 2

monitor = WDM::Monitor.new
changes = Queue.new
paths.keys.each do |path|
  monitor.watch_recursively(path) { |change| changes << change }
end
Thread.new { monitor.run! }

loop do
  directories = Set.new
  begin
    loop do
      change = Timeout::timeout(latency) {
        changes.pop
      }
      directories << change.path
    end
  rescue Timeout::Error
    @logger.info("Breaking out of the loop at #{Time.now.to_s}.")
  end

  @logger.info(directories.inspect) unless directories.empty?

  #@callback.call(paths, ignores, directories) unless directories.empty?
end

