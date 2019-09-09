require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do
  t.rspec_opts = '--require ./spec/spec_helper.rb'
end

task :default => :spec
