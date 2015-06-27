require "vagrant"

module VagrantPlugins
  module GatlingRsync
    class StartupRsync
      include Vagrant::Action::Builtin::MixinSyncedFolders

      def initialize(app, env)
        @app = app
        @gatling_startup_registered = false
        @rsync_folder_count = 0
      end

      def call(env)
        folders = synced_folders(env[:machine])
        @rsync_folder_count += folders[:rsync].size if folders.key?(:rsync)

        @app.call(env)

        # Ensure only one at_exit block is registered.
        return unless @gatling_startup_registered == false

        return unless env[:machine].config.gatling.rsync_on_startup == true

        at_exit do
          unless $!.is_a?(SystemExit)
            env[:ui].warn "Vagrant's startup was interrupted by an exception."
            exit 1
          end

          exit_status = $!.status
          if exit_status != 0
            env[:ui].warn "The previous process exited with exit code #{exit_status}."
            exit exit_status
          end

          # Don't run if there are no rsynced folders.
          unless @rsync_folder_count == 0 then
            env[:ui].info I18n.t("vagrant_gatling_rsync.startup_sync")
            env[:machine].env.cli("gatling-rsync-auto")
          end
        end

        @gatling_startup_registered = true
      end
    end
  end
end
