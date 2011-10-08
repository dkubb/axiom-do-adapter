# encoding: utf-8

require 'rubygems'
require 'backports'
require 'backports/basic_object' unless RUBY_VERSION >= '1.9.2' && (RUBY_PLATFORM.include?('java') || RUBY_ENGINE == 'rbx')
require 'spec'
require 'spec/autorun'
require 'veritas'
require 'veritas-sql-generator'

include Veritas

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require f }

Spec::Runner.configure do |config|
  config.extend Spec::ExampleGroupMethods

  # Record the original Attribute descendants
  config.before do
    @original_descendants = Attribute.descendants.dup
  end

  # Reset the Attribute descendants
  config.after do
    Attribute.descendants.replace(@original_descendants)
  end

end
