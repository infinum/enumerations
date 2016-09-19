require File.expand_path('../lib/enumerations/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'enumerations'
  s.version     = Enumerations::VERSION
  s.date        = '2016-09-15'
  s.summary     = 'Enumerations for ActiveRecord!'
  s.description = 'Extends ActiveRecord with enumeration capabilites.'
  s.homepage    = 'https://github.com/infinum/enumerations'

  s.authors     = [
    'Tomislav Car', 'Nikica Jokić', 'Nikola Santić', 'Stjepan Hadjić', 'Petar Ćurković'
  ]

  s.email = [
    'tomislav@infinum.hr', 'nikica.jokic@infinum.hr', 'nikola.santic@infinum.hr',
    'stjepan.hadjic@infinum.hr', 'petar.curkovic@infinum.hr'
  ]

  s.add_dependency 'activerecord'
  s.add_dependency 'activesupport'
  s.add_dependency 'i18n'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'sqlite3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
end
