require 'active_hash_methods'
class Doogle::DisplayMode < ActiveHash::Base
  self.data = [
    {:position => 1, :id => 1, :name => 'TN',       :long_name => 'Twisted Nematic'},
    {:position => 2, :id => 2, :name => 'STN',      :long_name => 'Super-Twisted Nematic', :doogle_name => 'STN (STN-Yellow)'},
    {:position => 3, :id => 6, :name => 'STN-Blue'},
    {:position => 4, :id => 7, :name => 'STN-Gray'},
    {:position => 5, :id => 3, :name => 'FSTN',     :long_name => 'Film Compensated STN'},
    {:position => 6, :id => 4, :name => 'DSTN',     :long_name => 'Dual Scan STN'},
    {:position => 7, :id => 5, :name => 'FFSTN',    :long_name => 'Double Film Super-Twist Nematic'},
    {:position => 8, :id => 8, :name => 'HTN',      :long_name => 'High Twisted Nematic'}
  ]
  include ActiveHashMethods
  
  def self.all
    super.sort_by(&:position)
  end
  
  def doogle_name
    self.attributes[:doogle_name] || self.name
  end

  # Override doogle form dropdowns.
  def self.member_label
    'doogle_name'
  end
end
