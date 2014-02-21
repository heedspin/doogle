require 'plutolib/active_hash_methods'
class Doogle::ViewingDirection < ActiveHash::Base
  self.data = [
    {:id => 1, :cmethod => 'twelve', :name => '12:00'},
    {:id => 5, :cmethod => 'one_thirty', :name => '1:30'},
    {:id => 2, :cmethod => 'three', :name => '3:00'},
    {:id => 6, :cmethod => 'four_thirty', :name => '4:30'},
    {:id => 3, :cmethod => 'six', :name => '6:00'},
    {:id => 7, :cmethod => 'seven_thirty', :name => '7:30'},
    {:id => 4, :cmethod => 'nine', :name => '9:00'},
    {:id => 8, :cmethod => 'ten_thirty', :name => '10:30'},
    {:id => 9, :cmethod => 'full', :name => 'Full'},
  ]
  include Plutolib::ActiveHashMethods
  
end
