require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('boo_hiss', '0.0.1') do |p|
  p.description    = "Generate a unique token with Active Record."
  p.url            = "http://github.com/halorgium/boo_hiss"
  p.author         = "Tim Carey-Smith"
  p.email          = "tim@halorgium.net"
  p.ignore_pattern = ["tmp/*", "script/*", "coverage/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

remove_task :default
task :default => "spec:all"
