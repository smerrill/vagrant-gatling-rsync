begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant gatling rsync plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.5.0"
  raise Errors::Vagrant15RequiredError
end

# @TODO: Bail out if not on Mac.

module VagrantPlugins
  module GatlingRsync
    class Plugin < Vagrant.plugin("2")
      name "Gatling Rsync"
      description <<-DESC
      Rsync large project directories to your Vagrant VM without using many resources on the host.
      DESC

      # This initializes the internationalization strings.
      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", GatlingRsync.source_root)
        I18n.reload!
      end

      command "gatling-rsync-auto" do
        setup_i18n

        require_relative "command/rsync_auto"
        GatlingRsyncAuto
      end
    end
  end
end
