require 'rubygems'
require 'rake'
require 'echoe'

$:.unshift File.dirname(__FILE__) + '/lib'
require 'boo_hiss/version'

Echoe.new('boo_hiss', BooHiss::VERSION) do |p|
  p.description    = "Mutate some code to see if it useful or not"
  p.url            = "http://github.com/halorgium/boo_hiss"
  p.author         = "Tim Carey-Smith"
  p.email          = "tim@halorgium.net"
  p.ignore_pattern = ["tmp/*", "script/*", "coverage/*"]
  p.runtime_dependencies = ["ruby2ruby >=1.2.1", "term-ansicolor >=1.0.3"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

remove_task :default
task :default => "spec:all"
