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

while true do
  directories = Set.new
  begin
    while true do
      change = Timeout::timeout(latency) {
        changes.pop
      }
      directories << change.path
    end
  rescue Timeout::Error
    puts "Breaking out of the loop at #{Time.now.to_s}"
  end
  puts directories.inspect

  #callback(paths, ignores, directories) if directories.size
end

