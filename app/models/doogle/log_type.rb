require 'plutolib/active_hash_methods'
class Doogle::LogType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Create'},
    {:id => 2, :name => 'Update'},
    {:id => 3, :name => 'Destroy'},
    {:id => 4, :name => 'Vendor Info', :cmethod => 'vendor'},
    {:id => 5, :name => 'Specification / Datasheet', :cmethod => 'spec'},
    {:id => 6, :name => 'Opportunity'},
    {:id => 7, :name => 'Quote'},
  ]
  include Plutolib::ActiveHashMethods
end
