# encoding: utf-8

source 'https://rubygems.org'

gemspec

gem 'axiom',               '~> 0.1.1', git: 'https://github.com/dkubb/axiom.git',               branch: 'master'
gem 'axiom-sql-generator', '~> 0.1.1', git: 'https://github.com/dkubb/axiom-sql-generator.git', branch: 'master'
gem 'axiom-types',         '~> 0.0.5', git: 'https://github.com/dkubb/axiom-types.git',         branch: 'master'

platform :rbx do
  gem 'rubysl-bigdecimal', '~> 2.0.2'
end

group :development, :test do
  gem 'devtools', git: 'https://github.com/rom-rb/devtools.git'
end

eval_gemfile 'Gemfile.devtools'
