require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/../lib/boo_hiss'

module BooHiss
  class ExampleGroup < Spec::ExampleGroup
    class Tester
      def initialize(klass, method_name, &block)
        @klass, @method_name, @block = klass, method_name, block
      end

      def passes?
        err, out = "", ""
        original = Spec::Runner.options
        options = Spec::Runner::Options.new(StringIO.new(err), StringIO.new(out))
        Spec::Runner.use(options)
        Spec::Runner.configure(&@block)
        result = Spec::Runner::CommandLine.run
        [result, err, out]
      ensure
        Spec::Runner.use(original)
      end
    end

    Spec::Example::ExampleGroupFactory.default(self)
  end
end
