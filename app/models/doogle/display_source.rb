require 'plutolib/active_hash_methods'
class Doogle::DisplaySource < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'LXD'},
    {:id => 2, :name => 'Jiya'},
    {:id => 3, :name => 'Multi-Inno'},
    {:id => 4, :name => 'Prime View'},
    {:id => 5, :name => 'Other'}
  ]
  include Plutolib::ActiveHashMethods
end
