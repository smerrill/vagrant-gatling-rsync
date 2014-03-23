require "log4r"
require "optparse"

require "listen"

require "vagrant"

module VagrantPlugins
  module GatlingRsync
    class GatlingRsyncAuto < Vagrant.plugin(2, :command)
      include Vagrant::Action::Builtin::MixinSyncedFolders

      def self.synopsis
        "syncs rsync synced folders when folders change"
      end

      def execute
        @logger = Log4r::Logger.new("vagrant::commands::gatling-rsync-auto")

        @plugin_os = case RUBY_PLATFORM
                       when /darwin/
                         :osx
                       when /linux/
                         :linux
                       else
                         # @TODO: Convert to a subclass of Vagrant::Errors::VagrantError.
                         raise "This plugin currently only supports Mac OS X and Linux hosts."
                     end

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant gatling-rsync-auto [vm-name]"
          o.separator ""
        end

        # Parse the options and return if we don't have any target.
        argv = parse_options(opts)
        return if !argv

        # Build up the paths that we need to listen to.
        paths = {}
        ignores = []
        with_target_vms(argv) do |machine|
          folders = synced_folders(machine)[:rsync]
          next if !folders || folders.empty?

          folders.each do |id, folder_opts|
            # If we marked this folder to not auto sync, then
            # don't do it.
            next if folder_opts.has_key?(:auto) && !folder_opts[:auto]

            hostpath = folder_opts[:hostpath]
            hostpath = File.expand_path(hostpath, machine.env.root_path)
            paths[hostpath] ||= []
            paths[hostpath] << {
              id: id,
              machine: machine,
              opts:    folder_opts,
            }

            if folder_opts[:exclude]
              Array(folder_opts[:exclude]).each do |pattern|
                ignores << RsyncHelper.exclude_to_regexp(hostpath, pattern.to_s)
              end
            end
          end
        end

        # Output to the user what paths we'll be watching
        paths.keys.sort.each do |path|
          paths[path].each do |path_opts|
            path_opts[:machine].ui.info(I18n.t(
              "vagrant.rsync_auto_path",
              path: path.to_s,
            ))
          end
        end

        @logger.info("Listening to paths: #{paths.keys.sort.inspect}")
        @logger.info("Ignoring #{ignores.length} paths:")
        ignores.each do |ignore|
          @logger.info("  -- #{ignore.to_s}")
        end
        @logger.info("Listening via: #{Listen::Adapter.select.inspect}")

        # @TODO: Check version.

        callback = method(:callback).to_proc.curry[paths]
        listener = Listen.to(*paths.keys, ignore: ignores, &callback)
        listener.start
        listener.thread.join

        0
      end

      # This is the callback that is called when any changes happen
      def callback(paths, modified, added, removed)
        @logger.info("File change callback called!")
        @logger.info("  - Modified: #{modified.inspect}")
        @logger.info("  - Added: #{added.inspect}")
        @logger.info("  - Removed: #{removed.inspect}")

        tosync = []
        paths.each do |hostpath, folders|
          # Find out if this path should be synced
          found = catch(:done) do
            [modified, added, removed].each do |changed|
              changed.each do |listenpath|
                throw :done, true if listenpath.start_with?(hostpath)
              end
            end

            # Make sure to return false if all else fails so that we
            # don't sync to this machine.
            false
          end

          # If it should be synced, store it for later
          tosync << folders if found
        end

        # Sync all the folders that need to be synced
        tosync.each do |folders|
          folders.each do |opts|
            ssh_info = opts[:machine].ssh_info
            RsyncHelper.rsync_single(opts[:machine], ssh_info, opts[:opts])
          end
        end
      end
    end
  end
end
