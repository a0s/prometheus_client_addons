require 'prometheus_client_addons/prometheus/client/formats/text_extended'
require 'prometheus_client_addons/prometheus/client/multi_metric'

module PrometheusClientAddons
  module Prometheus
    module Client
      class ActiveRecord < MultiMetric
        HANDLES = {
          size: 'Size of pool',
          connections: 'Connections count',
          busy: 'Busy count',
          dead: 'Dead count',
          idle: 'Idle count',
          waiting: 'Num waiting in queue',
          checkout_timeout: 'Checkout timeout'
        }.freeze

        def multi_name_type
          full_handles = HANDLES.keys.map { |key| "#{prefix}#{key}" }.map(&:to_sym)
          Hash[full_handles.zip([:gauge] * HANDLES.size)]
        end

        def multi_name_docstring
          Hash[HANDLES.map { |key, value| ["#{prefix}#{key}".to_sym, value] }]
        end

        def multi_values
          stat = ::ActiveRecord::Base.connection_pool.stat
          Hash[stat.map { |key, value| ["#{prefix}#{key}".to_sym, { {} => value }] }]
        end
      end
    end
  end
end
