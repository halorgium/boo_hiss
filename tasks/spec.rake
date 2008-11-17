require 'spec'
require 'spec/rake/spectask'

namespace :spec do
  Spec::Rake::SpecTask.new(:all) do |t|
    t.spec_opts << %w(-fs --color) << %w(-O spec/spec.opts)
    t.spec_opts << '--loadby' << 'random'
    t.spec_files = Dir["spec/**/*_spec.rb"]
    t.rcov = ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true
    t.rcov_opts << '--exclude' << 'spec'
    t.rcov_opts << '--text-summary'
    t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
  end
end
