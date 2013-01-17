require 'plutolib/active_hash_methods'
class Doogle::ApprovalStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Pending'},
    {:id => 2, :name => 'Approved',}
  ]
  include Plutolib::ActiveHashMethods
end
