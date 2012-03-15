require 'active_hash_methods'
class Doogle::DisplayMode < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'TN', :long_name => 'Twisted Nematic'},
    {:id => 2, :name => 'STN', :long_name => 'Super-Twisted Nematic'},
    {:id => 3, :name => 'FSTN', :long_name => 'Film Compensated STN'},
    {:id => 4, :name => 'DSTN', :long_name => 'Dual Scan STN'},
    {:id => 5, :name => 'FFSTN', :long_name => 'Double Film Super-Twist Nematic'},
  ]
  include ActiveHashMethods
end
