require 'puma/plugin'
require 'prometheus_client_addons/prometheus/client/puma'

module PrometheusClientAddons
  module Puma
    module Plugin
      ::Puma::Plugin.create do
        def start(launcher)
          control_url = launcher.options[:control_url]
          raise StandardError, "Need Puma's activate_control_app" if control_url == nil

          Prometheus::Client::Puma.tap do |puma|
            puma.control_url = control_url
            puma.control_auth_token = launcher.options[:control_auth_token]
          end
        end
      end
    end
  end
end
