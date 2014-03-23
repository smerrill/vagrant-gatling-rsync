require "log4r"
require 'optparse'

require "listen"

begin
  require "vagrant"
rescue LoadError
  raise "The gatling rsync command must be run within Vagrant."
end

#require "vagrant/action/builtin/mixin_synced_folders"

#require_relative "../helper"

module VagrantPlugins
  module GatlingRsync
    module Command
      class GatlingRsyncAuto < VagrantPlugins::SyncedFolderRSync::Command::RsyncAuto
      end
    end
  end
end
