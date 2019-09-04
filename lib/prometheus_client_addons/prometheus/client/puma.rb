require 'json'
require 'prometheus_client_addons/prometheus/client/formats/text_extended'
require 'prometheus_client_addons/prometheus/client/multi_metric'
require 'prometheus_client_addons/puma/plugin/prometheus_client_addons'

module PrometheusClientAddons
  module Prometheus
    module Client
      class Puma < MultiMetric
        class << self
          attr_accessor :control_url, :control_auth_token
        end

        HANDLES = {
          backlog: 'How many requests are waiting',
          running: 'Number of running threads',
          pool_capacity: 'Number of requests that can be processed right now',
          max_threads: 'Maximum number of worker threads',

          workers: 'Number of workers',
          phase: 'Phase of worker',
          booted_workers: 'Number of booted workers',
          old_workers: 'Number of old workers',

          worker_status_phase: 'Phase of worker',
          worker_status_booted: 'Booted or not',
          worker_status_last_checkin: 'Last update',

          worker_status_last_status_backlog: 'How many objects have yet to be processed by the pool',
          worker_status_last_status_running: 'Number of running threads',
          worker_status_last_status_pool_capacity: 'Number of requests that can be processed right now',
          worker_status_last_status_max_threads: 'Maximum number of worker threads'
        }.freeze

        def multi_name_type
          full_handles = HANDLES.keys.map { |key| "#{prefix}#{key}" }.map(&:to_sym)
          Hash[full_handles.zip([:gauge] * HANDLES.size)]
        end

        def multi_name_docstring
          Hash[HANDLES.map { |key, value| ["#{prefix}#{key}".to_sym, value] }]
        end

        def extract(input, output, nested, label_set = {})
          key = if input.key?(nested.last.to_s)
            nested.last.to_s
          elsif input.key?(nested.last.to_sym)
            nested.last.to_sym
          end
          return unless key

          output["#{prefix}#{nested.join('_')}".to_sym] ||= {}
          output["#{prefix}#{nested.join('_')}".to_sym][label_set] = input[key]
        end

        def multi_values
          body = Socket.unix(self.class.control_url.gsub("unix://", '')) do |socket|
            socket << "GET /stats?token=#{self.class.control_auth_token} HTTP/1.0\r\n\r\n"
            socket.read
          end

          data = JSON.parse(body.split("\n").last, symbolize_names: true)

          result = {}

          extract(data, result, [:backlog])
          extract(data, result, [:running])
          extract(data, result, [:pool_capacity])
          extract(data, result, [:max_threads])

          extract(data, result, [:workers])
          extract(data, result, [:phase])
          extract(data, result, [:booted_workers])
          extract(data, result, [:old_workers])

          if data.key?(:worker_status) && !data[:worker_status].empty?
            data[:worker_status].each do |worker_status|
              worker_index = worker_status[:index]

              extract(worker_status, result, [:worker_status, :phase], { worker_index: worker_index })
              extract(worker_status, result, [:worker_status, :booted], { worker_index: worker_index })
              extract(worker_status, result, [:worker_status, :last_checkin], { worker_index: worker_index })

              last_status = worker_status[:last_status]
              extract(last_status, result, [:worker_status, :last_status, :backlog], { worker_index: worker_index })
              extract(last_status, result, [:worker_status, :last_status, :running], { worker_index: worker_index })
              extract(last_status, result, [:worker_status, :last_status, :pool_capacity], { worker_index: worker_index })
              extract(last_status, result, [:worker_status, :last_status, :max_threads], { worker_index: worker_index })
            end
          end

          result
        end
      end
    end
  end
end
