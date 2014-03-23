require "vagrant"

module VagrantPlugins
  module GatlingRsync
    module Errors
      class VagrantGatlingRsyncError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_gatling_rsync.errors")
      end

      class OnlyOSXLinuxSupportError < VagrantGatlingRsyncError
        error_key(:only_osx_linux_support)
      end

      class Vagrant15RequiredError < VagrantGatlingRsyncError
        error_key(:vagrant_15_required)
      end
    end
  end
end
