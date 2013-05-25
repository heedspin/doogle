require 'plutolib/active_hash_methods'
class Doogle::StandardClassification < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Standard Part', :cmethod => 'standard'},
    {:id => 2, :name => 'Custom Part', :cmethod => 'custom'},
    {:id => 4, :name => 'Untooled Standard Part', :cmethod => 'untooled_standard'},
    {:id => 3, :name => 'Untooled Custom Part', :cmethod => 'untooled_custom'},
  ]
  include Plutolib::ActiveHashMethods
end
