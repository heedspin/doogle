require 'active_hash_setter'
require 'acts_as_list'

class Doogle::Display < ApplicationModel
  self.inheritance_column = '_disabled'
  def type
    read_attribute(:type)
  end

  belongs_to :status
  belongs_to :source, :class_name => 'DisplaySource'
  belongs_to :timing_controller_type
  belongs_to :touch_panel_type
  belongs_to :specification_type
  validates_uniqueness_of :model_number

  has_attached_file( :datasheet,
                     :storage => :s3,
                     :s3_credentials => "#{Rails.root}/config/s3.yml",
                     :url => ':s3_domain_url',
                     :bucket => 'lxd-ds',
                     :path => "displays/:basename.:extension" )

  acts_as_list
  def scope_condition
    "type = '#{type}'"
  end

  scope :not_deleted, lambda {
    {
      :conditions => ['displays.status_id != ?', Doogle::Status.deleted.id]
    }
  }
  scope :published, lambda {
    {
      :conditions => ['displays.status_id = ?', Doogle::Status.published.id]
    }
  }
  scope :type_in, lambda { |*types|
    type_keys = types.flatten.map { |t| t.is_a?(Doogle::DisplayConfig) ? t.key : t.to_s }
    {
      :conditions => [ 'displays.type in (?)', type_keys ]
    }
  }
  scope :for_model, lambda { |model_number|
    {
      :conditions => { :model_number => model_number }
    }
  }
  scope :by_model_number, :order => :model_number
  scope :resolution_x, lambda { |x_range|
    if x_range.exact?
      {
        :conditions => { :resolution_x => x_range.exact }
      }
    else
      {
        :conditions => [ 'displays.resolution_x >= ? and displays.resolution_x <= ?', x_range.min, x_range.max ]
      }
    end
  }
  scope :by_resolution, :order => [ :resolution_x, :resolution_y ]
  scope :storage_temperature_min, lambda { |val|
    {
      :conditions => [ 'displays.storage_temperature_min <= ?', val ]
    }
  }
  scope :storage_temperature_max, lambda { |val|
    {
      :conditions => [ 'displays.storage_temperature_max >= ?', val ]
    }
  }
  scope :operational_temperature_min, lambda { |val|
    {
      :conditions => [ 'displays.operational_temperature_min <= ?', val ]
    }
  }
  scope :operational_temperature_max, lambda { |val|
    {
      :conditions => [ 'displays.operational_temperature_max >= ?', val ]
    }
  }
  scope :diagonal_inches, lambda { |diagonal_inches_range|
    if diagonal_inches_range.exact?
      {
        :conditions => { :module_diagonal_in => diagonal_inches_range.exact }
      }
    elsif diagonal_inches_range.no_max?
      {
        :conditions => [ 'displays.module_diagonal_in >= ?', diagonal_inches_range.min ]
      }
    else
      {
        :conditions => [ 'displays.module_diagonal_in >= ? AND displays.module_diagonal_in <= ?', diagonal_inches_range.min, diagonal_inches_range.max ]
      }
    end
  }

  def destroy
    self.update_attributes(:status_id => Status.deleted.id)
  end

  def model_and_id
    "id: #{id} #{model_number}"
  end

  # **********************************

  def display_name
    self.display_config.name
  end

  def display_config
    t = self.read_attribute(:type)
    Doogle::DisplayConfig.find_by_key(t) || (raise "No display config for #{t}")
  end

  def is_display_of?(dc)
    self.display_config.key == dc.key
  end

  # puts Display.unused_datasheets.join("\n")
  def self.unused_datasheets
    Dir.glob(Doogle::Engine.root + 'public/ds/*.pdf').select { |p| Display.count(:conditions => "data_sheet_path like '%#{File.basename(p)}'") == 0}
  end

  def source=(thing)
    if thing.is_a?(DisplaySource)
      write_attribute(:source_id, thing.id)
    elsif thing.is_a?(String)
      if new_source = DisplaySource.find_by_name(thing)
        write_attribute(:source_id, new_source.id)
      else
        raise "#{thing} is not a valid #{Display.human_attribute_name(:source)}"
      end
    elsif thing.nil?
      write_attribute(:source_id, nil)
    else
      raise ActiveRecord::AssociationTypeMismatch.new("Expected DisplaySource, got #{thing.class.name} #{thing.to_s}")
    end
  end

  def lcd_type_index
    if self.lcd_type =~ /^[^\d]*(\d+)[^\d]*(\d+)[^\d]*$/
      char_graphic_index = self.lcd_type.downcase.include?('char') ? 1 : 2
      [char_graphic_index, $1.to_i, $2.to_i]
    else
      self.lcd_type
    end
  end

  def graphic_display?
    case self.display_config.key
    when :glass_displays
      false
    when :module_displays
      self.lcd_type.include?('Graph')
    else
      true
    end
  end

  def resolution_xy
    if self.resolution_x && self.resolution_y
      "#{self.resolution_x} x #{self.resolution_y}"
    else
      nil
    end
  end

  # rails console
  # Display.find_each { |d| d.guess_resolutions ; d.save if d.changed? }
  def guess_resolutions
    if !self.graphic_display?
      self.resolution_x ||= nil
      self.resolution_y ||= nil
    else
      search_attribute = if self.display_config.active_field?(:resolution)
        self.resolution
      elsif self.display_config.active_field?(:pixel_configuration)
        self.pixel_configuration
      elsif self.display_config.active_field?(:lcd_type)
        self.lcd_type
      end
      return unless search_attribute
      if search_attribute =~ /(\d+)[^\d]+(\d+)/
        self.resolution_x ||= $1
        self.resolution_y ||= $2
      end
    end
  end

  def storage_temperature_min_max
    if self.storage_temperature_min and self.storage_temperature_max
      "#{self.storage_temperature_min}&deg; to #{self.storage_temperature_max}&deg;C".html_safe
    else
      nil
    end
  end

  # rails console
  # Display.find_each { |d| d.guess_temperatures ; d.save if d.changed? }
  def guess_temperatures
    if self.storage_temperature =~ /(\d+)[^\d]+(\d+)/
      self.storage_temperature_min ||= $1
      self.storage_temperature_max ||= $2
    end
    if self.operational_temperature =~ /(\d+)[^\d]+(\d+)/
      self.operational_temperature_min ||= $1
      self.operational_temperature_max ||= $2
    end
  end
  
  MM_PER_INCH = 25.4
  def guess_module_dimensions
    if self.diagonal_size.present? and !self.diagonal_size.include?('WIDE')
      self.module_diagonal_in = self.diagonal_size.to_f
    else
      self.module_diagonal_in = nil
    end
    if self.module_dimensions and ((numbers = self.module_dimensions.scan(/(?:\d+\.\d+)|(?:\d+)/)).size > 1)
      width = numbers[0].to_f
      height = numbers[1].to_f
      thickness = numbers[2].to_f
      is_in_inches = width <= 10
      doit = Proc.new { |n| 
        if n == 0
          nil
        elsif is_in_inches
          n * MM_PER_INCH
        else
          n
        end
      }
      self.module_width_mm = doit.call(width)
      self.module_height_mm = doit.call(height)
      self.module_thickness_mm = doit.call(thickness)
      self.module_diagonal_in ||= if self.module_width_mm and self.module_height_mm and (self.module_width_mm > 0) and (self.module_height_mm > 0)
        Math.sqrt(self.module_width_mm * self.module_width_mm + self.module_height_mm * self.module_height_mm) / MM_PER_INCH
      else
        nil
      end
    end
  end
  
  def module_diagonal_in_rounded
    if self.module_diagonal_in > 0
      sprintf("%.1f",self.module_diagonal_in) + '"'
    else
      nil
    end
  end

  # rails console
  # Display.find_each { |d| d.guess_ranges! }
  def guess_ranges!
    self.guess_resolutions
    self.guess_temperatures
    self.guess_module_dimensions
    self.save if self.changed?
  end

  include ActiveHashSetter
  active_hash_setter(Doogle::Status)
  active_hash_setter(Doogle::TouchPanelType)
  active_hash_setter(Doogle::TimingControllerType)
  active_hash_setter(Doogle::SpecificationType)
end

Paperclip.interpolates :model_number do |attachment, style|
  attachment.instance.model_number
end

# == Schema Information
#
# Table name: displays
#
#  id                          :integer(4)      not null, primary key
#  type                        :string(255)
#  model_number                :string(255)
#  number_of_digits            :string(255)
#  technology_type             :string(255)
#  module_dimensions           :string(255)
#  digit_height                :string(255)
#  polarizer_mode              :string(255)
#  number_of_pins              :string(255)
#  configuration               :string(255)
#  lcd_type                    :string(255)
#  viewing_dimensions          :string(255)
#  diagonal_size               :string(255)
#  dot_format                  :string(255)
#  brightness                  :string(255)
#  contrast                    :string(255)
#  backlight_type              :string(255)
#  backlight_color             :string(255)
#  viewing_angle               :string(255)
#  operational_temperature     :string(255)
#  storage_temperature         :string(255)
#  interface                   :string(255)
#  resolution                  :string(255)
#  weight                      :string(255)
#  power_consumption           :string(255)
#  active_area                 :string(255)
#  outline_dimensions          :string(255)
#  view_direction              :string(255)
#  bonding_type                :string(255)
#  pixel_configuration         :string(255)
#  controller                  :string(255)
#  operating_voltage           :string(255)
#  status_id                   :integer(4)
#  creator_id                  :integer(4)
#  updater_id                  :integer(4)
#  created_at                  :datetime
#  updated_at                  :datetime
#  position                    :integer(4)
#  colors                      :string(255)
#  dot_size                    :string(255)
#  dot_pitch                   :string(255)
#  thickness                   :string(255)
#  integrated_circuit          :string(255)
#  panel_size                  :string(255)
#  source_id                   :integer(4)
#  source_model_number         :string(255)
#  datasheet_file_name         :string(255)
#  datasheet_content_type      :string(255)
#  datasheet_file_size         :integer(4)
#  datasheet_updated_at        :datetime
#  touch_panel_type_id         :integer(4)
#  timing_controller_type_id   :integer(4)
#  specification_type_id       :integer(4)
#  resolution_x                :integer(4)
#  resolution_y                :integer(4)
#  storage_temperature_min     :integer(4)
#  storage_temperature_max     :integer(4)
#  operational_temperature_min :integer(4)
#  operational_temperature_max :integer(4)
#  module_width_mm             :float
#  module_height_mm            :float
#  module_thickness_mm         :float
#  module_diagonal_in          :float
#

