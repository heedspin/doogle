require 'active_hash'
class Doogle::Search
  extend ActiveHash::Associations::ActiveRecordExtensions

  cattr_accessor :attributes
  def self.add_attribute(attribute, class_name=nil)
    self.attributes ||= []
    self.attributes.push(attribute)
    if class_name.nil?
      self.class_eval <<-RUBY
        attr_accessor '#{attribute}'
      RUBY
    else
      self.class_eval <<-RUBY
        attr_accessor '#{attribute}_id'
        belongs_to_active_hash '#{attribute}', :class_name => '#{class_name}'
      RUBY
    end
  end
  add_attribute :type_key
  add_attribute :model_number
  add_attribute :resolution_x_range, 'Doogle::ResolutionXRange'
  add_attribute :storage_temperature_min_range, 'Doogle::StorageTemperatureMinRange'
  add_attribute :module_diagonal_in_range, 'Doogle::DiagonalInchesRange'
  add_attribute :bonding_type, 'Doogle::BondingType'
  add_attribute :backlight_color, 'Doogle::Color'
  add_attribute :graphic_type, 'Doogle::GraphicType'
  add_attribute :character_columns_range, 'Doogle::CharacterColumnRange'
  add_attribute :luminance_nits_range, 'Doogle::LuminanceRange'

  def initialize(params)
    params ||= {}
    params.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def filter(display_scope)
    self.class.attributes.each do |attribute|
      if (value = self.send(attribute)).present?
        # Rails.logger.debug "Scoping #{attribute} to #{value}"
        display_scope = display_scope.send(attribute, value)
      end
    end
    display_scope
  end
end
