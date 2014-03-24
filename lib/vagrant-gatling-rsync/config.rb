require "vagrant"

module VagrantPlugins
  module GatlingRsync
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :latency

      def initialize
        @latency = UNSET_VALUE
      end

      def finalize!
        @latency = 1.5 if @latency == UNSET_VALUE
      end

      # @TODO: This does not appear to be called.
      def validate(machine)
        require "pry"
        binding.pry
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
