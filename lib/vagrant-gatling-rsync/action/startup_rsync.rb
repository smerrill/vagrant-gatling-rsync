require "vagrant"

module VagrantPlugins
  module GatlingRsync
    class StartupRsync
      def initialize(app, env)
        @app = app
      end

      def call(env)
        @app.call(env)
        at_exit do
          # @TODO: Ensure this only happens once.

          unless $!.is_a?(SystemExit)
            env[:ui].warn "Vagrant's startup was interrupted by an exception."
            exit 1
          end

          exit_status = $!.status
          if exit_status != 0
            env[:ui].warn "The previous process exited with exit code #{exit_status}."
            exit exit_status
          end

          # @TODO: Translate.
          env[:ui].info "Invoking gatling-rsync-auto."
          env[:machine].env.cli("gatling-rsync-auto")
        end
      end
    end
  end
end
