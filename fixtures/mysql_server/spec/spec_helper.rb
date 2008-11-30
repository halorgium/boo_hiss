MOUNT_POINT = File.expand_path(File.dirname(__FILE__) + '/../mount') unless Object.const_defined?(:MOUNT_POINT)

require 'rubygems'
require 'spec'
require 'rr'

require File.dirname(__FILE__) + '/../lib/system'
require File.dirname(__FILE__) + '/../lib/mysql_server'

require File.dirname(__FILE__) + '/mocks/mysql_server_mock'

Spec::Runner.configure do |spec|
  spec.mock_with :rr
end

class MockSystem
  def self.reset!
    @system = nil
  end

  def self.run(command)
    puts "Running #{command}"
    @system ||= new
    @system.run(command)
  end

  def initialize
    @mocks = [MysqlServerMock.new]
  end

  def run(command)
    i, m = find_mock(command)
    raise "Unhandled command: #{command}" unless m
    i.send(m, command)
  end

  def find_mock(command)
    @mocks.each do |i|
      m = i.locate(command)
      return [i, m] if m
    end
  end
end
