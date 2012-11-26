require 'plutolib/active_hash_methods'
class Doogle::ViewingDirection < ActiveHash::Base
  self.data = [
    {:position => 1, :id => 1, :cmethod => 'twelve', :name => '12:00'},
    {:position => 2, :id => 5, :cmethod => 'one_thirty', :name => '1:30'},
    {:position => 3, :id => 2, :cmethod => 'three', :name => '3:00'},
    {:position => 4, :id => 6, :cmethod => 'four_thirty', :name => '4:30'},
    {:position => 5, :id => 3, :cmethod => 'six', :name => '6:00'},
    {:position => 6, :id => 7, :cmethod => 'seven_thirty', :name => '7:30'},
    {:position => 7, :id => 4, :cmethod => 'nine', :name => '9:00'},
    {:position => 8, :id => 8, :cmethod => 'ten_thirty', :name => '10:30'},
  ]
  include Plutolib::ActiveHashMethods
  
  def self.all
    super.sort_by(&:position)
  end
  
  
end
