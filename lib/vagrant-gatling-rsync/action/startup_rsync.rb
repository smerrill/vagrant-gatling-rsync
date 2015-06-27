require "vagrant"

module VagrantPlugins
  module GatlingRsync
    class StartupRsync
      def initialize(app, env)
        @app = app
        @gatling_startup_registered = false
      end

      def call(env)
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

          env[:ui].info I18n.t("vagrant_gatling_rsync.startup_sync")
          env[:machine].env.cli("gatling-rsync-auto")
        end

        @gatling_startup_registered = true
      end
    end
  end
end
