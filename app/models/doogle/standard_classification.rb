require 'active_hash_methods'
class Doogle::StandardClassification < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Standard Part', :cmethod => 'standard'},
    {:id => 2, :name => 'Custom Part', :cmethod => 'custom'},
  ]
  include ActiveHashMethods
end
