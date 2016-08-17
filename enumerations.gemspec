require File.expand_path('../lib/enumerations/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'enumerations'
  s.version     = Enumeration::VERSION
  s.date        = '2016-08-15'
  s.summary     = 'Enumerations for ActiveRecord!'
  s.description = 'Extends ActiveRecord with enumeration capabilites.'
  s.authors     = ['Tomislav Car', 'Nikica Jokic', 'Nikola Santic']
  s.email       = ['tomislav@infinum.hr', 'nikica.jokic@infinum.hr', 'nikola.santic@infinum.hr']
  s.homepage    = 'https://github.com/infinum/enumerations'

  s.add_dependency 'activerecord'
  s.add_dependency 'activesupport'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'sqlite3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
end
