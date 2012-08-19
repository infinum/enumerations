Gem::Specification.new do |s|
  s.name        = 'enumerations'
  s.version     = '1.1.0'
  s.date        = '2010-08-20'
  s.summary     = "Enumerations for ActiveRecord!"
  s.description = "Extends ActiveRecord with enumeration capabilites."
  s.authors     = ["Tomislav Car", "Nikica Jokic", "Nikola Santic"]
  s.email       = ["tomislav@infinum.hr", "nikica.jokic@infinum.hr", "nikola.santic@infinum.hr"]
  s.homepage    = 'https://github.com/infinum/enumerations'
  
  s.add_dependency 'activerecord'
  s.add_dependency 'activesupport'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")  
end
