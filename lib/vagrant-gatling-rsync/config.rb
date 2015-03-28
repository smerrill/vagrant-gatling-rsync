require "vagrant"

module VagrantPlugins
  module GatlingRsync
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :latency
      attr_accessor :time_format
      attr_accessor :rsync_on_startup

      def initialize
        @latency = UNSET_VALUE
        @time_format = UNSET_VALUE
        @rsync_on_startup = UNSET_VALUE
      end

      def finalize!
        @latency = 1.5 if @latency == UNSET_VALUE
        @time_format = "%I:%M:%S %p" if @time_format == UNSET_VALUE
        if @rsync_on_startup == UNSET_VALUE
          @rsync_on_startup = false
        else
          @rsync_on_startup = !!@rsync_on_startup
        end
      end

      # @TODO: This does not appear to be called.
      def validate(machine)
        errors = _detected_errors

        if @latency == UNSET_VALUE
          return
        elsif not @latency.is_a? Numeric
          @latency = 1.5
          # @TODO: Translate.
          errors << "The latency must be set to a number. Substituting 1.5 as a value."
        elsif @latency < 0.2
          @latency = 0.2
          # @TODO: Translate.
          errors << "The latency may not be below 0.2 seconds."
        end

        { "gatling" => errors }
      end
    end
  end
end
