require 'prometheus/client/metric'

module PrometheusClientAddons
  module Prometheus
    module Client
      class CustomCollector < ::Prometheus::Client::Metric
        def initialize(name:, docstring:, base_labels: {}, &block)
          @custom_collector = block
          super(name.to_sym, docstring, base_labels)
        end

        def get(labels = {})
          @custom_collector.call
        end

        def values
          { {} => @custom_collector.call }
        end

        def type
          :gauge
        end
      end
    end
  end
end
