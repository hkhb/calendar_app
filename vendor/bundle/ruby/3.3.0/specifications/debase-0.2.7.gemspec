# -*- encoding: utf-8 -*-
# stub: debase 0.2.7 ruby lib
# stub: ext/extconf.rb ext/attach/extconf.rb

Gem::Specification.new do |s|
  s.name = "debase".freeze
  s.version = "0.2.7".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alexandr Evstigneev".freeze, "Dennis Ushakov".freeze]
  s.date = "2024-11-12"
  s.description = "    debase is a fast implementation of the standard Ruby debugger debug.rb for Ruby 2.0+.\n    It is implemented by utilizing a new Ruby TracePoint class. The core component\n    provides support that front-ends can build on. It provides breakpoint\n    handling, bindings for stack frames among other things.\n".freeze
  s.email = ["hurricup@gmail.com".freeze, "dennis.ushakov@gmail.com".freeze]
  s.extensions = ["ext/extconf.rb".freeze, "ext/attach/extconf.rb".freeze]
  s.files = ["ext/attach/extconf.rb".freeze, "ext/extconf.rb".freeze]
  s.homepage = "https://github.com/ruby-debug/debase".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.3.7".freeze
  s.summary = "debase is a fast implementation of the standard Ruby debugger debug.rb for Ruby 2.0+".freeze

  s.installed_by_version = "3.5.16".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<debase-ruby_core_source>.freeze, [">= 3.3.6".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
end
