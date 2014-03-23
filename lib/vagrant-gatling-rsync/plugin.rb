require "vagrant"

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.5.0"
  # @TODO: Convert to a subclass of Vagrant::Errors::VagrantError.
  raise "The Vagrant gatling rsync plugin requires Vagrant 1.5 or newer."
end

# @TODO: Bail out if not on Mac.

module VagrantPlugins
  module GatlingRsync
    class Plugin < Vagrant.plugin("2")
      name "Gatling Rsync"
      description <<-DESC
      Rsync large project directories to your Vagrant VM without using many resources on the host.
      DESC

      command "gatling-rsync-auto" do
        require_relative "command/rsync_auto"
        GatlingRsyncAuto
      end

    end
  end
end
