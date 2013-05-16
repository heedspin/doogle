require 'plutolib/active_hash_methods'
class Doogle::StandardClassification < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Standard Part', :cmethod => 'standard'},
    {:id => 2, :name => 'Custom Part', :cmethod => 'custom'},
    {:id => 3, :name => 'Untooled Custom Part', :cmethod => 'untooled'}
  ]
  include Plutolib::ActiveHashMethods
end
