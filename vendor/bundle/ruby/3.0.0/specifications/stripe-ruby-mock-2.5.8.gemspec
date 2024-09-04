# -*- encoding: utf-8 -*-
# stub: stripe-ruby-mock 2.5.8 ruby lib

Gem::Specification.new do |s|
  s.name = "stripe-ruby-mock".freeze
  s.version = "2.5.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Gilbert".freeze]
  s.date = "2019-06-25"
  s.description = "A drop-in library to test stripe without hitting their servers".freeze
  s.email = "gilbertbgarza@gmail.com".freeze
  s.executables = ["stripe-mock-server".freeze]
  s.files = ["bin/stripe-mock-server".freeze]
  s.homepage = "https://github.com/rebelidealist/stripe-ruby-mock".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.5".freeze
  s.summary = "TDD with stripe".freeze

  s.installed_by_version = "3.3.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<stripe>.freeze, [">= 2.0.3"])
    s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.0"])
    s.add_runtime_dependency(%q<dante>.freeze, [">= 0.2.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
    s.add_development_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2"])
    s.add_development_dependency(%q<thin>.freeze, ["~> 1.6.4"])
  else
    s.add_dependency(%q<stripe>.freeze, [">= 2.0.3"])
    s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
    s.add_dependency(%q<dante>.freeze, [">= 0.2.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
    s.add_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2"])
    s.add_dependency(%q<thin>.freeze, ["~> 1.6.4"])
  end
end
