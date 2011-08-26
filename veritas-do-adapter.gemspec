# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{veritas-do-adapter}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Dan Kubb}]
  s.date = %q{2011-08-26}
  s.description = %q{Use Veritas relations with an RDBMS}
  s.email = %q{dan.kubb@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    ".document",
    ".gemtest",
    ".rvmrc",
    ".travis.yml",
    "Gemfile",
    "Guardfile",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "TODO",
    "config/flay.yml",
    "config/flog.yml",
    "config/roodi.yml",
    "config/site.reek",
    "config/yardstick.yml",
    "lib/veritas-do-adapter.rb",
    "lib/veritas/adapter/data_objects.rb",
    "lib/veritas/adapter/data_objects/statement.rb",
    "lib/veritas/adapter/data_objects/version.rb",
    "spec/rcov.opts",
    "spec/shared/idempotent_method_behaviour.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/unit/veritas/adapter/data_objects/read_spec.rb",
    "spec/unit/veritas/adapter/data_objects/statement/each_spec.rb",
    "spec/unit/veritas/adapter/data_objects/statement/generator_spec.rb",
    "spec/unit/veritas/adapter/data_objects/statement/to_s_spec.rb",
    "tasks/metrics/ci.rake",
    "tasks/metrics/flay.rake",
    "tasks/metrics/flog.rake",
    "tasks/metrics/heckle.rake",
    "tasks/metrics/metric_fu.rake",
    "tasks/metrics/reek.rake",
    "tasks/metrics/roodi.rake",
    "tasks/metrics/yardstick.rake",
    "tasks/spec.rake",
    "tasks/yard.rake",
    "veritas-do-adapter.gemspec"
  ]
  s.homepage = %q{https://github.com/dkubb/veritas-do-adapter}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Vertias DataObjects adapter}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<data_objects>, ["~> 0.10.6"])
      s.add_runtime_dependency(%q<veritas>, ["~> 0.0.6"])
      s.add_runtime_dependency(%q<veritas-sql-generator>, ["~> 0.0.6"])
      s.add_development_dependency(%q<backports>, ["~> 2.3.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.2"])
      s.add_development_dependency(%q<yard>, ["~> 0.7.2"])
    else
      s.add_dependency(%q<data_objects>, ["~> 0.10.6"])
      s.add_dependency(%q<veritas>, ["~> 0.0.6"])
      s.add_dependency(%q<veritas-sql-generator>, ["~> 0.0.6"])
      s.add_dependency(%q<backports>, ["~> 2.3.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<rspec>, ["~> 1.3.2"])
      s.add_dependency(%q<yard>, ["~> 0.7.2"])
    end
  else
    s.add_dependency(%q<data_objects>, ["~> 0.10.6"])
    s.add_dependency(%q<veritas>, ["~> 0.0.6"])
    s.add_dependency(%q<veritas-sql-generator>, ["~> 0.0.6"])
    s.add_dependency(%q<backports>, ["~> 2.3.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<rspec>, ["~> 1.3.2"])
    s.add_dependency(%q<yard>, ["~> 0.7.2"])
  end
end

