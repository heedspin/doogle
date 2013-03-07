require 'plutolib/active_hash_methods'
class Doogle::Color < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'None', :aliases => %w(n/a na)},
    {:id => 2, :name => 'Amber'},
    {:id => 3, :name => 'Blue'},
    {:id => 4, :name => 'Green', :aliases => %w(grn)},
    {:id => 5, :name => 'RGB'},
    {:id => 6, :name => 'White', :aliases => %w(wht)},
    {:id => 7, :name => 'Yellow-Green', :aliases => %w(y/g)},
    {:id => 8, :name => 'Gray'},
    {:id => 9, :name => 'White-Red'}
  ]
  include Plutolib::ActiveHashMethods
  
  def self.find_by_name_or_alias(txt)
    return nil unless txt.present?
    txt = txt.downcase.strip
    self.all.detect { |bc| (bc.name.downcase == txt) || (bc.aliases.present? && bc.aliases.include?(txt)) }
  end
end
