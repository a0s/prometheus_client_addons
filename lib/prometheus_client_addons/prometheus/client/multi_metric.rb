require 'prometheus/client/metric'
require 'prometheus/client/label_set_validator'

module PrometheusClientAddons
  module Prometheus
    module Client
      class MultiMetric < ::Prometheus::Client::Metric
        attr_reader :name, :prefix, :base_labels

        def initialize(prefix: '', base_labels: {})
          prefix = "#{prefix}_" unless prefix == ''

          @prefix = prefix
          @name = prefix
          @base_labels = base_labels

          multi_name_type.keys.each { |name| validate_name("#{prefix}#{name}".to_sym) }
          multi_name_docstring.keys.each { |name| validate_name("#{prefix}#{name}".to_sym) }
          multi_name_docstring.values.each(&method(:validate_docstring))
          @validator = ::Prometheus::Client::LabelSetValidator.new
          @validator.valid?(base_labels)
        end

        def multi_name_type
          fail('Should return hash {name => type}')
        end

        def multi_name_docstring
          fail('Should return hash {name => docstrings}')
        end

        def multi_values
          fail('Should return hash {name => {label_set => value, label_set => value, }}')
        end
      end
    end
  end
end
