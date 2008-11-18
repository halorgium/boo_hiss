# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{boo_hiss}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Carey-Smith"]
  s.date = %q{2008-11-18}
  s.description = %q{Generate a unique token with Active Record.}
  s.email = %q{tim@halorgium.net}
  s.extra_rdoc_files = ["README.rdoc", "lib/boo_hiss/mob.rb", "lib/boo_hiss/mutator.rb", "lib/boo_hiss/processor.rb", "lib/boo_hiss/reaper.rb", "lib/boo_hiss/reporter.rb", "lib/boo_hiss/silent_reporter.rb", "lib/boo_hiss.rb", "tasks/extensions.rake", "tasks/spec.rake"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "boo_hiss.gemspec", "lib/boo_hiss/mob.rb", "lib/boo_hiss/mutator.rb", "lib/boo_hiss/processor.rb", "lib/boo_hiss/reaper.rb", "lib/boo_hiss/reporter.rb", "lib/boo_hiss/silent_reporter.rb", "lib/boo_hiss.rb", "spec/mob_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/extensions.rake", "tasks/spec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/halorgium/boo_hiss}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Boo_hiss", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{boo_hiss}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Generate a unique token with Active Record.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
