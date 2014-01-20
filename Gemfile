# encoding: utf-8

source 'https://rubygems.org'

gemspec

gem 'adamantium',          '~> 0.1',     git: 'https://github.com/dkubb/adamantium.git',          branch: 'master'
gem 'axiom',               '~> 0.1.1',   git: 'https://github.com/dkubb/axiom.git',               branch: 'master'
gem 'axiom-sql-generator', '~> 0.1.1',   git: 'https://github.com/dkubb/axiom-sql-generator.git', branch: 'master'
gem 'axiom-types',         '~> 0.0.5',   git: 'https://github.com/dkubb/axiom-types.git',         branch: 'master'
gem 'data_objects',        '~> 0.10.13', git: 'https://github.com/datamapper/do.git',             branch: 'master'

group :development, :test do
  gem 'devtools', git: 'https://github.com/rom-rb/devtools.git'
end

eval_gemfile 'Gemfile.devtools'
