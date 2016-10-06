require File.expand_path('../lib/foreman_datacenter/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_datacenter'
  s.version     = ForemanDatacenter::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Pavel Ivanov']
  s.email       = ['ivpavig@gmail.com']
  s.homepage    = 'https://github.com/cloudevelops/foreman_datacenter'
  s.summary     = 'A plugin that lets you document your servers in a datacenter'
  # also update locale/gemspec.rb
  s.description = 'A plugin that lets you document your servers in a datacenter'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_dependency 'prawn', '~> 2.1'
  s.add_dependency 'rqrcode', '~> 0.10.1'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rails', ['= 4.2.6']
end
