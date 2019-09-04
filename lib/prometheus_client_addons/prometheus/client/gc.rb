require 'prometheus_client_addons/prometheus/client/formats/text_extended'
require 'prometheus_client_addons/prometheus/client/multi_metric'

module PrometheusClientAddons
  module Prometheus
    module Client
      class GC < MultiMetric
        KEYS = [
          :count,
          :heap_allocated_pages,
          :heap_sorted_length,
          :heap_allocatable_pages,
          :heap_available_slots,
          :heap_live_slots,
          :heap_free_slots,
          :heap_final_slots,
          :heap_marked_slots,
          :heap_eden_pages,
          :heap_tomb_pages,
          :total_allocated_pages,
          :total_freed_pages,
          :total_allocated_objects,
          :total_freed_objects,
          :malloc_increase_bytes,
          :malloc_increase_bytes_limit,
          :minor_gc_count,
          :major_gc_count,
          :remembered_wb_unprotected_objects,
          :remembered_wb_unprotected_objects_limit,
          :old_objects,
          :old_objects_limit,
          :oldmalloc_increase_bytes,
          :oldmalloc_increase_bytes_limit
        ].freeze

        HANDLES = Hash[KEYS.zip(KEYS)].freeze

        def multi_name_type
          full_handles = HANDLES.keys.map { |key| "#{prefix}#{key}" }.map(&:to_sym)
          Hash[full_handles.zip([:gauge] * HANDLES.size)]
        end

        def multi_name_docstring
          Hash[HANDLES.map { |key, value| ["#{prefix}#{key}".to_sym, value] }]
        end

        def multi_values
          stat = ::GC.stat
          Hash[stat.map { |key, value| ["#{prefix}#{key}".to_sym, { {} => value }] }]
        end
      end
    end
  end
end
