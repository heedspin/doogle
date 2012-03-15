require 'active_hash_methods'
class Doogle::TargetEnvironment < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Indoor'},
    {:id => 2, :name => 'Sunlight Readable'}
  ]
  include ActiveHashMethods
end
