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

  s.add_dependency "rails", ">= 3.2.13", "< 6.0.0"
  # s.add_dependency 'declarative_authorization'
  s.add_dependency "acts_as_list", '0.2.0'
  s.add_dependency "active_hash"
  s.add_dependency 'aws-sdk', '1.66' #, :require => 'aws/s3'
  # Paperclip 5 drops support for aws-sdk 1 and requires aws-sdk 2.0 or later
  s.add_dependency 'paperclip', '< 5'
  s.add_dependency 'activeresource'
  # s.add_dependency 'spreadsheet', '0.6.8'
end
