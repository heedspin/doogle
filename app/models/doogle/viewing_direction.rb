require 'active_hash_methods'
class Doogle::ViewingDirection < ActiveHash::Base
  self.data = [
    {:position => 1, :id => 1, :method => 'twelve', :name => '12:00'},
    {:position => 2, :id => 5, :method => 'one_thirty', :name => '1:30'},
    {:position => 3, :id => 2, :method => 'three', :name => '3:00'},
    {:position => 4, :id => 6, :method => 'four_thirty', :name => '4:30'},
    {:position => 5, :id => 3, :method => 'six', :name => '6:00'},
    {:position => 6, :id => 7, :method => 'seven_thirty', :name => '7:30'},
    {:position => 7, :id => 4, :method => 'nine', :name => '9:00'},
    {:position => 8, :id => 8, :method => 'ten_thirty', :name => '10:30'},
  ]
  include ActiveHashMethods
  
  def self.all
    super.sort_by(&:position)
  end
  
  
end
