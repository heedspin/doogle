$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doogle/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doogle"
  s.version     = Doogle::VERSION
  s.authors     = ["Tim Harrison"]
  s.email       = ["heedspin@gmail.com"]
  s.homepage    = "https://github.com/heedspin/doogle"
  s.summary     = "Searchable database of LCDs for LXD"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "acts_as_list"
  s.add_dependency 'aws-sdk' #, :require => 'aws/s3'
  # s.add_development_dependency "sqlite3"
end
