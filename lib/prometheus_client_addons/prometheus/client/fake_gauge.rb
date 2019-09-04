module PrometheusClientAddons
  module Prometheus
    module Client
      FakeGauge = Struct.new(:name, :docstring, :base_labels) do
        def initialize(*)
          self.base_labels ||= {}
          super
        end

        def type
          :gauge
        end
      end

    end
  end
end
