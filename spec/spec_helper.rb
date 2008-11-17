require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/fixtures'
require File.dirname(__FILE__) + '/../lib/boo_hiss'

module BooHiss
  class ExampleGroup < Spec::ExampleGroup
    def parse(string)
      ParseTree.new.parse_tree_for_string(string).first
    end

    Spec::Example::ExampleGroupFactory.default(self)
  end
end

