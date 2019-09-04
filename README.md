# Prometheus Ruby Client Addons

## Usage

### Puma stats

config/initializers/prometheus.rb
```ruby
require 'prometheus/client'
require 'prometheus_client_addons'

prometheus = Prometheus::Client.registry
puma = PrometheusClientAddons::Prometheus::Client::Puma.new(prefix: 'puma', base_labels: { my_label: 'baz' })
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

### ActiveRecord::ConnectionPool stats

*Not it's not working with pre-forked/clustered-mode web servers. Sorry.*

config/initializers/prometheus.rb
```ruby
require 'prometheus/client'
require 'prometheus_client_addons'

prometheus = Prometheus::Client.registry
pool = PrometheusClientAddons::Prometheus::Client::ActiveRecord.new(prefix: 'activerecord', base_labels: { my_label: 'foo' })
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
