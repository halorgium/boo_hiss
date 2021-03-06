$:.unshift File.dirname(__FILE__)

module BooHiss
  class Error < StandardError; end
end

require 'rubygems'
require 'pp'
require 'ruby2ruby'
require 'parse_tree'
require 'tempfile'

require 'boo_hiss/reporter'
require 'boo_hiss/silent_reporter'
require 'boo_hiss/default_reporter'
require 'boo_hiss/formatted_reporter'

require 'boo_hiss/cli'
require 'boo_hiss/mob'
require 'boo_hiss/reaper'
require 'boo_hiss/mutator'
require 'boo_hiss/processor'
