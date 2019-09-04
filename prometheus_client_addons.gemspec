lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "prometheus_client_addons/version"

Gem::Specification.new do |spec|
  spec.name = "prometheus_client_addons"
  spec.version = PrometheusClientAddons::VERSION
  spec.authors = ["Anton Osenenko"]
  spec.email = ["anton.osenenko@gmail.com"]

  spec.summary = 'The missed parts of prometheus/client_ruby'
  spec.description = 'The missed parts of prometheus/client_ruby'
  spec.homepage = "https://github.com/a0s/prometheus_client_addons"
  spec.license = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "prometheus-client", "~> 0.9.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "puma"
end
