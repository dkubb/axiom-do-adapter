# encoding: utf-8

require 'rake'

require File.expand_path('../lib/veritas/adapter/data_objects/version', __FILE__)

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'veritas-do-adapter'
    gem.summary     = 'Vertias DataObjects adapter'
    gem.description = 'Use Veritas relations with an RDBMS'
    gem.email       = 'dan.kubb@gmail.com'
    gem.homepage    = 'https://github.com/dkubb/veritas-do-adapter'
    gem.authors     = [ 'Dan Kubb' ]

    gem.version = Veritas::Adapter::DataObjects::VERSION
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
