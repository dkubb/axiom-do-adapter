module Spec
  module ExampleGroupMethods
    def testing_block_passing_broken?
      RUBY_PLATFORM.include?('java') && JRUBY_VERSION <= '1.7.0.dev' && RUBY_VERSION >= '1.9.2'
    end
  end
end
