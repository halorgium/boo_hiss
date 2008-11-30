namespace :spec do
  task :all do
    require "test/spec_forker"
    SpecForker.run("spec/**/*_spec.rb", 'spec', ENV['RSPEC_OPTS'] || '-c', [])
  end
end
