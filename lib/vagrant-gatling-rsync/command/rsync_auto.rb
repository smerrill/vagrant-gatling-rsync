require "log4r"
require "optparse"

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

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant gatling-rsync-auto [vm-name]"
          o.separator ""
        end

        # Parse the options and return if we don't have any target.
        argv = parse_options(opts)
        return if !argv

        latency = nil

        # Build up the paths that we need to listen to.
        paths = {}
        ignores = []
        with_target_vms(argv) do |machine|
          latency = machine.config.gatling.latency

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
              opts: folder_opts,
            }

            if folder_opts[:exclude]
              Array(folder_opts[:exclude]).each do |pattern|
                ignores << VagrantPlugins::SyncedFolderRSync::RsyncHelper.exclude_to_regexp(hostpath, pattern.to_s)
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

        case RUBY_PLATFORM
        when /darwin/
          ListenOSX.new(paths, ignores, latency, @logger, self.method(:callback)).run
        when /linux/
          ListenLinux.new(paths, ignores, latency, @logger, self.method(:callback)).run
        else
          # @TODO: Raise this earlier?
          raise Errors::OnlyOSXLinuxSupportError
        end

        0
      end

      # This callback gets called when any directory changes.
      def callback(paths, ignores, modified)
        @logger.info("File change callback called!")
        @logger.info("  - Paths: #{paths.inspect}")
        @logger.info("  - Ignores: #{ignores.inspect}")
        @logger.info("  - Modified: #{modified.inspect}")

        tosync = []
        paths.each do |hostpath, folders|
          # Find out if this path should be synced
          found = catch(:done) do
            modified.each do |changed|
              match = nil
              ignores.each do |ignore|
                next unless match.nil?
                match = ignore.match(changed)
              end

              next unless match.nil?
              throw :done, true if changed.start_with?(hostpath)
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
            do_rsync(opts[:machine], ssh_info, opts[:opts]) if ssh_info
          end
        end
      end

      def do_rsync(machine, ssh_info, opts)
        start_time = Time.new
        VagrantPlugins::SyncedFolderRSync::RsyncHelper.rsync_single(machine, ssh_info, opts)
        end_time = Time.new
        machine.ui.info(I18n.t(
          "vagrant_gatling_rsync.gatling_ran",
          date: end_time.strftime(machine.config.gatling.time_format),
          milliseconds: (end_time - start_time) * 1000))
      end
    end
  end
end
