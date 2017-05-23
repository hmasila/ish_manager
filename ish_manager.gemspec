$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ish_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ish_manager"
  s.version     = IshManager::VERSION
  s.authors     = ["piousbox"]
  s.email       = ["piousbox@gmail.com"]
  s.homepage    = "http://wasya.co"
  s.summary     = "Summary of IshManager."
  s.description = "Description of IshManager."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", [ "~> 5.1" ]
  s.add_dependency "activeadmin", [ "~> 1.0" ]
  s.add_dependency "haml", [ '~> 5.0' ]
  s.add_dependency "cancancan", [ "~> 2.0" ]
  s.add_dependency "devise", [ "~> 4.3" ]

  ## such garbage!
  # s.add_dependency "bootstrap", [ "~> 4.0.0.alpha6" ]
  # s.add_dependency "jquery-rails", "> 0"

end
