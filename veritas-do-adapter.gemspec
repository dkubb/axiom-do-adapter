# encoding: utf-8

require File.expand_path('../lib/veritas/adapter/data_objects/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'veritas-do-adapter'
  gem.version     = Veritas::Adapter::DataObjects::VERSION.dup
  gem.authors     = ['Dan Kubb']
  gem.email       = 'dan.kubb@gmail.com'
  gem.description = 'Use Veritas relations with an RDBMS'
  gem.summary     = 'Vertias DataObjects adapter'
  gem.homepage    = 'https://github.com/dkubb/veritas-do-adapter'
  gem.licenses    = %w[MIT]

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec/{unit,integration}`.split($/)
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_runtime_dependency('data_objects',          '~> 0.10.12')
  gem.add_runtime_dependency('veritas',               '~> 0.0.7')
  gem.add_runtime_dependency('veritas-sql-generator', '~> 0.0.7')

  gem.add_development_dependency('rake',  '~> 10.0.4')
  gem.add_development_dependency('rspec', '~> 2.13.0')
  gem.add_development_dependency('yard',  '~> 0.8.5.2')
end
