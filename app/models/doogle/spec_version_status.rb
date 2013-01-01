require 'plutolib/active_hash_methods'
class Doogle::SpecVersionStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Latest Revision', :cmethod => 'latest' },
    {:id => 2, :name => 'Previous Revision', :cmethod => 'previous' },
    {:id => 3, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
