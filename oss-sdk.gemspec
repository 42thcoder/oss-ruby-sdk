# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "#{lib}/aliyun/oss/version"

Gem::Specification.new do |spec|
  spec.name          = 'aliyun-ruby-oss'
  spec.version       = Aliyun::OSS::VERSION
  spec.authors       = ['42thcoder']
  spec.email         = ['42thcoder@gmail.com']

  spec.summary       = %q{oss sdk.}
  spec.description   = %q{oss sdk.}
  spec.homepage      = 'http://github.com/42thcoder'
  spec.license       = 'Apache License, version 2.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'webmock', '~> 1.22'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'redcarpet', '~> 3.3'
  spec.add_development_dependency 'github-markup', '~> 1.4'
  spec.add_development_dependency 'task_list'
  spec.add_development_dependency 'pry-byebug', '~> 3.2'
  spec.add_development_dependency 'coveralls', '~> 0.8'

  spec.add_runtime_dependency 'activesupport', '~> 4.2'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'nori', '~> 2.6'
  spec.add_runtime_dependency 'dotenv', '~> 2.0'
  spec.add_runtime_dependency 'virtus'
end
