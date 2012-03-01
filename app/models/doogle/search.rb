require 'active_hash'
class Doogle::Search
  extend ActiveHash::Associations::ActiveRecordExtensions
  attr_accessor :resolution_x_range_id
  belongs_to_active_hash :resolution_x_range, :class_name => 'Doogle::ResolutionXRange'

  attr_accessor :type
  
  attr_accessor :storage_temperature_min_range_id
  belongs_to_active_hash :storage_temperature_min_range, :class_name => 'Doogle::StorageTemperatureMinRange'
  
  attr_accessor :diagonal_inches_range_id
  belongs_to_active_hash :diagonal_inches_range, :class_name => 'Doogle::DiagonalInchesRange'
  
  def initialize(params)
    params ||= {}
    self.resolution_x_range_id = params['resolution_x_range_id']
    self.type = params['type']
    self.storage_temperature_min_range_id = params['storage_temperature_min_range_id']
    self.diagonal_inches_range_id = params['diagonal_inches_range_id']
  end
  
  def filter(display_scope)
    if self.resolution_x_range
      display_scope = display_scope.resolution_x(self.resolution_x_range)
    end
    if self.type.present?
      display_scope = display_scope.type_in(self.type)
    end
    if self.storage_temperature_min_range.present?
      display_scope = display_scope.storage_temperature_min(self.storage_temperature_min_range.min)
    end
    if self.diagonal_inches_range.present?
      display_scope = display_scope.diagonal_inches(self.diagonal_inches_range)
    end
    display_scope
  end
end