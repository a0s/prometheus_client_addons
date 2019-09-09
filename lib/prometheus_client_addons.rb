module PrometheusClientAddons
end

require "prometheus_client_addons/version"
require 'prometheus_client_addons/prometheus/client/puma'
require 'prometheus_client_addons/prometheus/client/active_record'
require 'prometheus_client_addons/prometheus/client/custom_collector'
require 'prometheus_client_addons/prometheus/client/gc'
require 'prometheus_client_addons/puma/plugin/prometheus_client_addons'
