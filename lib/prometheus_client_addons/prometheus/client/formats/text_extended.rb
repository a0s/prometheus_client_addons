require 'prometheus/middleware/exporter'
require 'prometheus/client/formats/text'
require 'prometheus_client_addons/prometheus/client/multi_metric'
require 'prometheus_client_addons/prometheus/client/fake_gauge'

module PrometheusClientAddons
  module Prometheus
    module Client
      module Formats
        TextExtended = ::Prometheus::Client::Formats::Text.dup

        module TextExtended
          def self.marshal(registry)
            lines = []

            registry.metrics.each do |metric|
              if metric.is_a?(MultiMetric)
                metric.multi_values.each do |name, values|
                  lines << format(self::TYPE_LINE, name, metric.multi_name_type[name])
                  lines << format(self::HELP_LINE, name, escape(metric.multi_name_docstring[name]))

                  values.each do |label_set, value|
                    _metric = FakeGauge.new(name, metric.multi_name_docstring[name], metric.base_labels)
                    representation(_metric, label_set, value) { |l| lines << l }
                  end
                end
              else
                lines << format(self::TYPE_LINE, metric.name, metric.type)
                lines << format(self::HELP_LINE, metric.name, escape(metric.docstring))

                metric.values.each do |label_set, value|
                  representation(metric, label_set, value) { |l| lines << l }
                end
              end
            end

            (lines << nil).join(self::DELIMITER)
          end
        end
      end
    end
  end
end

Prometheus::Middleware::Exporter.send(:remove_const, 'FORMATS')
Prometheus::Middleware::Exporter.send(:remove_const, 'FALLBACK')
Prometheus::Middleware::Exporter.send(:const_set, 'FORMATS', [PrometheusClientAddons::Prometheus::Client::Formats::TextExtended].freeze)
Prometheus::Middleware::Exporter.send(:const_set, 'FALLBACK', PrometheusClientAddons::Prometheus::Client::Formats::TextExtended)
