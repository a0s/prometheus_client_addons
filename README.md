# Prometheus Ruby Client Addons

## Usage (with Rails)

### Puma server

config/initializers/prometheus.rb
```ruby
require 'prometheus/client'
require 'prometheus_client_addons'

prometheus = Prometheus::Client.registry
puma = PrometheusClientAddons::Prometheus::Client::Puma.new(
  prefix: 'puma', 
  base_labels: { my_label: 'baz' }
)
prometheus.register(puma)
```

config/puma.rb
```ruby
activate_control_app('auto')
plugin :prometheus_client_addons
```

Example response in non-clustered mode
```
# TYPE puma_backlog gauge
# HELP puma_backlog How many requests are waiting
puma_backlog{my_label="baz"} 0
# TYPE puma_running gauge
# HELP puma_running Number of running threads
puma_running{my_label="baz"} 5
# TYPE puma_pool_capacity gauge
# HELP puma_pool_capacity Number of requests that can be processed right now
puma_pool_capacity{my_label="baz"} 4
# TYPE puma_max_threads gauge
# HELP puma_max_threads Maximum number of worker threads
puma_max_threads{my_label="baz"} 5
```

Example response in clustered mode
```
# TYPE puma_workers gauge
# HELP puma_workers Number of workers
puma_workers{my_label="baz"} 2
# TYPE puma_phase gauge
# HELP puma_phase Phase of worker
puma_phase{my_label="baz"} 0
# TYPE puma_booted_workers gauge
# HELP puma_booted_workers Number of booted workers
puma_booted_workers{my_label="baz"} 2
# TYPE puma_old_workers gauge
# HELP puma_old_workers Number of old workers
puma_old_workers{my_label="baz"} 0
# TYPE puma_worker_status_phase gauge
# HELP puma_worker_status_phase Phase of worker
puma_worker_status_phase{my_label="baz",worker_index="0"} 0
puma_worker_status_phase{my_label="baz",worker_index="1"} 0
# TYPE puma_worker_status_booted gauge
# HELP puma_worker_status_booted Booted or not
puma_worker_status_booted{my_label="baz",worker_index="0"} true
puma_worker_status_booted{my_label="baz",worker_index="1"} true
# TYPE puma_worker_status_last_checkin gauge
# HELP puma_worker_status_last_checkin Last update
puma_worker_status_last_checkin{my_label="baz",worker_index="0"} 2019-09-04T15:01:33Z
puma_worker_status_last_checkin{my_label="baz",worker_index="1"} 2019-09-04T15:01:33Z
# TYPE puma_worker_status_last_status_backlog gauge
# HELP puma_worker_status_last_status_backlog How many objects have yet to be processed by the pool
puma_worker_status_last_status_backlog{my_label="baz",worker_index="0"} 0
puma_worker_status_last_status_backlog{my_label="baz",worker_index="1"} 0
# TYPE puma_worker_status_last_status_running gauge
# HELP puma_worker_status_last_status_running Number of running threads
puma_worker_status_last_status_running{my_label="baz",worker_index="0"} 5
puma_worker_status_last_status_running{my_label="baz",worker_index="1"} 5
# TYPE puma_worker_status_last_status_pool_capacity gauge
# HELP puma_worker_status_last_status_pool_capacity Number of requests that can be processed right now
puma_worker_status_last_status_pool_capacity{my_label="baz",worker_index="0"} 5
puma_worker_status_last_status_pool_capacity{my_label="baz",worker_index="1"} 5
# TYPE puma_worker_status_last_status_max_threads gauge
# HELP puma_worker_status_last_status_max_threads Maximum number of worker threads
puma_worker_status_last_status_max_threads{my_label="baz",worker_index="0"} 5
puma_worker_status_last_status_max_threads{my_label="baz",worker_index="1"} 5
```

### ActiveRecord::Base.connection_pool.stat

*Now it's not working with pre-forked/clustered-mode web servers. Sorry.*

config/initializers/prometheus.rb
```ruby
require 'prometheus/client'
require 'prometheus_client_addons'

prometheus = Prometheus::Client.registry
pool = PrometheusClientAddons::Prometheus::Client::ActiveRecord.new(
  prefix: 'activerecord', 
  base_labels: { my_label: 'foo' }
)
prometheus.register(pool)
```

Example response
```
# TYPE activerecord_size gauge
# HELP activerecord_size Size of pool
activerecord_size{my_label="foo"} 5
# TYPE activerecord_connections gauge
# HELP activerecord_connections Connections count
activerecord_connections{my_label="foo"} 0
# TYPE activerecord_busy gauge
# HELP activerecord_busy Busy count
activerecord_busy{my_label="foo"} 0
# TYPE activerecord_dead gauge
# HELP activerecord_dead Dead count
activerecord_dead{my_label="foo"} 0
# TYPE activerecord_idle gauge
# HELP activerecord_idle Idle count
activerecord_idle{my_label="foo"} 0
# TYPE activerecord_waiting gauge
# HELP activerecord_waiting Num waiting in queue
activerecord_waiting{my_label="foo"} 0
# TYPE activerecord_checkout_timeout gauge
# HELP activerecord_checkout_timeout Checkout timeout
activerecord_checkout_timeout{my_label="foo"} 5
```

### GC.stat

config/initializers/prometheus.rb
```ruby
require 'prometheus/client'
require 'prometheus_client_addons'

prometheus = Prometheus::Client.registry
gc = PrometheusClientAddons::Prometheus::Client::GC.new(
  prefix: 'gc',
  base_labels: { my_label: 'foo' }
)
prometheus.register(gc)
```

Example response
```
# TYPE gc_count gauge
# HELP gc_count count
gc_count{my_label="foo"} 62
# TYPE gc_heap_allocated_pages gauge
# HELP gc_heap_allocated_pages heap_allocated_pages
gc_heap_allocated_pages{my_label="foo"} 3593
# TYPE gc_heap_sorted_length gauge
# HELP gc_heap_sorted_length heap_sorted_length
gc_heap_sorted_length{my_label="foo"} 3593
# TYPE gc_heap_allocatable_pages gauge
# HELP gc_heap_allocatable_pages heap_allocatable_pages
gc_heap_allocatable_pages{my_label="foo"} 0
# TYPE gc_heap_available_slots gauge
# HELP gc_heap_available_slots heap_available_slots
gc_heap_available_slots{my_label="foo"} 1464501
# TYPE gc_heap_live_slots gauge
# HELP gc_heap_live_slots heap_live_slots
gc_heap_live_slots{my_label="foo"} 1464445
# TYPE gc_heap_free_slots gauge
# HELP gc_heap_free_slots heap_free_slots
gc_heap_free_slots{my_label="foo"} 56
# TYPE gc_heap_final_slots gauge
# HELP gc_heap_final_slots heap_final_slots
gc_heap_final_slots{my_label="foo"} 0
# TYPE gc_heap_marked_slots gauge
# HELP gc_heap_marked_slots heap_marked_slots
gc_heap_marked_slots{my_label="foo"} 999525
# TYPE gc_heap_eden_pages gauge
# HELP gc_heap_eden_pages heap_eden_pages
gc_heap_eden_pages{my_label="foo"} 3593
# TYPE gc_heap_tomb_pages gauge
# HELP gc_heap_tomb_pages heap_tomb_pages
gc_heap_tomb_pages{my_label="foo"} 0
# TYPE gc_total_allocated_pages gauge
# HELP gc_total_allocated_pages total_allocated_pages
gc_total_allocated_pages{my_label="foo"} 3593
# TYPE gc_total_freed_pages gauge
# HELP gc_total_freed_pages total_freed_pages
gc_total_freed_pages{my_label="foo"} 0
# TYPE gc_total_allocated_objects gauge
# HELP gc_total_allocated_objects total_allocated_objects
gc_total_allocated_objects{my_label="foo"} 4665284
# TYPE gc_total_freed_objects gauge
# HELP gc_total_freed_objects total_freed_objects
gc_total_freed_objects{my_label="foo"} 3200839
# TYPE gc_malloc_increase_bytes gauge
# HELP gc_malloc_increase_bytes malloc_increase_bytes
gc_malloc_increase_bytes{my_label="foo"} 16693664
# TYPE gc_malloc_increase_bytes_limit gauge
# HELP gc_malloc_increase_bytes_limit malloc_increase_bytes_limit
gc_malloc_increase_bytes_limit{my_label="foo"} 30330547
# TYPE gc_minor_gc_count gauge
# HELP gc_minor_gc_count minor_gc_count
gc_minor_gc_count{my_label="foo"} 48
# TYPE gc_major_gc_count gauge
# HELP gc_major_gc_count major_gc_count
gc_major_gc_count{my_label="foo"} 14
# TYPE gc_remembered_wb_unprotected_objects gauge
# HELP gc_remembered_wb_unprotected_objects remembered_wb_unprotected_objects
gc_remembered_wb_unprotected_objects{my_label="foo"} 4357
# TYPE gc_remembered_wb_unprotected_objects_limit gauge
# HELP gc_remembered_wb_unprotected_objects_limit remembered_wb_unprotected_objects_limit
gc_remembered_wb_unprotected_objects_limit{my_label="foo"} 8690
# TYPE gc_old_objects gauge
# HELP gc_old_objects old_objects
gc_old_objects{my_label="foo"} 992074
# TYPE gc_old_objects_limit gauge
# HELP gc_old_objects_limit old_objects_limit
gc_old_objects_limit{my_label="foo"} 1743172
# TYPE gc_oldmalloc_increase_bytes gauge
# HELP gc_oldmalloc_increase_bytes oldmalloc_increase_bytes
gc_oldmalloc_increase_bytes{my_label="foo"} 37700816
# TYPE gc_oldmalloc_increase_bytes_limit gauge
# HELP gc_oldmalloc_increase_bytes_limit oldmalloc_increase_bytes_limit
gc_oldmalloc_increase_bytes_limit{my_label="foo"} 33438324
```

### CustomCollector

config/initializers/prometheus.rb
```ruby
require 'prometheus/client'
require 'prometheus_client_addons'

prometheus = Prometheus::Client.registry
custom_collector = PrometheusClientAddons::Prometheus::Client::CustomCollector.new(
  name: 'custom_metric',
  docstring: 'This is a custom metric',
  base_labels: { my_label: 'foo' },
  &Proc.new {
    # return custom value from block
    Time.now.to_i
  }
)
prometheus.register(custom_collector)
```

Example response
```
# TYPE custom_metric gauge
# HELP custom_metric This is a custom metric
custom_metric{my_label="foo"} 1567612321
```

## Installation

```ruby
gem 'prometheus_client_addons'
```

```bash
bundle install
# or
gem install prometheus_client_addons
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/prometheus_client_addons.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
