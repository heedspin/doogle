# == Schema Information
#
# Table name: displays
#
#  id                                :integer(4)      not null, primary key
#  type_key                          :string(255)
#  model_number                      :string(255)
#  _number_of_digits                 :string(255)
#  _technology_type                  :string(255)
#  _module_dimensions                :string(255)
#  _digit_height                     :string(255)
#  _polarizer_mode                   :string(255)
#  _number_of_pins                   :string(255)
#  _configuration                    :string(255)
#  _lcd_type                         :string(255)
#  _viewing_dimensions               :string(255)
#  _diagonal_size                    :string(255)
#  _dot_format                       :string(255)
#  _brightness                       :string(255)
#  _contrast                         :string(255)
#  _backlight_type                   :string(255)
#  _backlight_color                  :string(255)
#  _viewing_angle                    :string(255)
#  _operational_temperature          :string(255)
#  _storage_temperature              :string(255)
#  _interface                        :string(255)
#  _resolution                       :string(255)
#  _weight                           :string(255)
#  _power_consumption                :string(255)
#  _active_area                      :string(255)
#  _outline_dimensions               :string(255)
#  _view_direction                   :string(255)
#  _bonding_type                     :string(255)
#  _pixel_configuration              :string(255)
#  integrated_controller             :string(255)
#  _operating_voltage                :string(255)
#  status_id                         :integer(4)
#  creator_id                        :integer(4)
#  updater_id                        :integer(4)
#  created_at                        :datetime
#  updated_at                        :datetime
#  position                          :integer(4)
#  colors                            :string(255)
#  _dot_size                         :string(255)
#  _dot_pitch                        :string(255)
#  _thickness                        :string(255)
#  _integrated_circuit               :string(255)
#  _panel_size                       :string(255)
#  source_id                         :integer(4)
#  source_model_number               :string(255)
#  datasheet_file_name               :string(255)
#  datasheet_content_type            :string(255)
#  datasheet_file_size               :integer(4)
#  datasheet_updated_at              :datetime
#  touch_panel_type_id               :integer(4)
#  timing_controller_type_id         :integer(4)
#  specification_type_id             :integer(4)
#  resolution_x                      :integer(4)
#  resolution_y                      :integer(4)
#  storage_temperature_min           :integer(4)
#  storage_temperature_max           :integer(4)
#  operational_temperature_min       :integer(4)
#  operational_temperature_max       :integer(4)
#  module_width_mm                   :decimal(12, 4)
#  module_height_mm                  :decimal(12, 4)
#  module_thickness_mm               :decimal(12, 4)
#  module_diagonal_in                :decimal(12, 4)
#  bonding_type_id                   :integer(4)
#  backlight_color_id                :integer(4)
#  graphic_type_id                   :integer(4)
#  character_rows                    :decimal(12, 4)
#  character_columns                 :decimal(12, 4)
#  luminance_nits                    :integer(4)
#  display_mode_id                   :integer(4)
#  pixel_color_id                    :integer(4)
#  display_image_id                  :integer(4)
#  viewing_width_mm                  :decimal(12, 4)
#  viewing_height_mm                 :decimal(12, 4)
#  polarizer_mode_id                 :integer(4)
#  character_type_id                 :integer(4)
#  active_area_width_mm              :decimal(12, 4)
#  active_area_height_mm             :decimal(12, 4)
#  backlight_type_id                 :integer(4)
#  interface_id                      :integer(4)
#  icon_type_id                      :integer(4)
#  comments                          :text
#  standard_classification_id        :integer(4)
#  mask_type_id                      :integer(4)
#  background_color_id               :integer(4)
#  logic_operating_voltage           :decimal(12, 4)
#  target_environment_id             :integer(4)
#  viewing_direction_id              :integer(4)
#  digit_height_mm                   :decimal(12, 4)
#  total_power_consumption           :decimal(12, 4)
#  no_of_pins                        :integer(4)
#  contrast_ratio                    :integer(4)
#  field_of_view                     :integer(4)
#  current_revision                  :boolean(1)
#  revision                          :string(255)
#  approval_status_id                :integer(4)
#  publish_to_erp                    :boolean(1)
#  erp_id                            :integer(4)
#  publish_to_web                    :boolean(1)
#  web_id                            :integer(4)
#  needs_pushed_to_web               :boolean(1)
#  viewing_cone                      :integer(4)
#  datasheet_public                  :boolean(1)
#  source_specification_file_name    :string(255)
#  source_specification_content_type :string(255)
#  source_specification_file_size    :integer(4)
#  source_specification_updated_at   :datetime
#  specification_file_name           :string(255)
#  specification_content_type        :string(255)
#  specification_file_size           :integer(4)
#  specification_updated_at          :datetime
#  specification_public              :boolean(1)
#  drawing_file_name                 :string(255)
#  drawing_content_type              :string(255)
#  drawing_file_size                 :integer(4)
#  drawing_updated_at                :datetime
#  drawing_public                    :boolean(1)
#

# tim@concerto:~/Dropbox/p/lxd_m2mhub$ bundle exec annotate --model-dir ../doogle/app/models
#

require 'active_hash_setter'
require 'acts_as_list'

class Doogle::Display < ApplicationModel
  validates_uniqueness_of :model_number

  attr_accessor :display_type
  include ActiveHashSetter
  active_hash_setter(Doogle::Status)
  active_hash_setter(Doogle::TouchPanelType)
  active_hash_setter(Doogle::BondingType)
  active_hash_setter(Doogle::Color, :backlight_color)
  active_hash_setter(Doogle::Color, :pixel_color)
  active_hash_setter(Doogle::Color, :background_color)
  active_hash_setter(Doogle::DisplayMode)
  active_hash_setter(Doogle::DisplaySource, :source)
  active_hash_setter(Doogle::DisplayImage)
  active_hash_setter(Doogle::PolarizerMode)
  active_hash_setter(Doogle::CharacterType)
  active_hash_setter(Doogle::BacklightType)
  active_hash_setter(Doogle::TargetEnvironment)
  active_hash_setter(Doogle::ViewingDirection)
  active_hash_setter(Doogle::IconType)
  active_hash_setter(Doogle::MaskType)
  active_hash_setter(Doogle::StandardClassification)
  has_many :display_interface_types, :class_name => 'Doogle::DisplayInterfaceType', :dependent => :destroy
  has_many :interface_types, :through => :display_interface_types, :source => :interface_type

  [ [:datasheet, ':display_type/:model_number/:model_number_datasheet.:extension'],
    [:specification, ':display_type/:model_number/:model_number_spec.:extension'],
    [:source_specification, ':display_type/:model_number/:model_number_source_spec.:extension'],
    [:drawing, ':display_type/:model_number/:model_number_drawing_:style.:extension', {:thumbnail => '100>', :medium => '400>', :large => '600>'}]
  ].each do |key, path, image_styles|
    options = { :storage => :s3,
                :s3_credentials => { :access_key_id => AppConfig.doogle_access_key_id,
                                     :secret_access_key => AppConfig.doogle_secret_access_key },
                :url => ':s3_domain_url',
                :bucket => AppConfig.doogle_bucket,
                :s3_permissions => 'authenticated-read',
                :path => path }
    options[:styles] = image_styles if image_styles
    has_attached_file key, options
  end

  acts_as_list
  def scope_condition
    "type_key = '#{type_key}'"
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
  scope :display_type, lambda { |*types|
    type_keys = types.flatten.map { |t| t.is_a?(Doogle::DisplayConfig) ? t.key : t.to_s }
    {
      :conditions => [ 'displays.type_key in (?)', type_keys ]
    }
  }
  scope :type_key, lambda { |key|
    {
      :conditions => { :type_key => key }
    }
  }
  scope :for_model, lambda { |model_number|
    {
      :conditions => { :model_number => model_number }
    }
  }
  scope :by_model_number, :order => :model_number
  scope :by_resolution, :order => [ :resolution_x, :resolution_y ]
  scope :model_number, lambda { |text|
    {
      :conditions => [ 'LOWER(displays.model_number) like ?', '%' + (text.strip.downcase || '') + '%' ]
    }
  }
  scope :integrated_controller, lambda { |text|
    {
      :conditions => [ 'LOWER(displays.integrated_controller) like ?', '%' + (text.strip.downcase || '') + '%' ]
    }
  }
  scope :interface_types, lambda { |itypes|
    {
      :joins => :display_interface_types,
      :conditions => [ 'display_interface_types.interface_type_id in (?)', itypes.map(&:id) ]
    }
  }
  scope :comments, lambda { |text|
    {
      :conditions => [ 'LOWER(displays.comments) like ?', '%' + (text.strip.downcase || '') + '%' ]
    }
  }
  scope :web, :conditions => { :publish_to_web => true }

  def destroy
    self.update_attributes(:status_id => Doogle::Status.deleted.id)
  end

  def model_and_id
    "id: #{id} #{model_number}"
  end

  # **********************************

  def display_name
    self.display_type.name
  end

  def display_type
    Doogle::DisplayConfig.find_by_key(self.type_key)
  end
  def display_type=(thing)
    if thing.is_a?(Doogle::DisplayConfig)
      write_attribute(:type_key, thing.key)
    elsif thing.is_a?(String) and thing.present?
      if dt = Doogle::DisplayConfig.find_by_key(thing)
        write_attribute(:type_key, dt.key)
      else
        raise "#{thing} is not a valid Doogle::DisplayConfig"
      end
    elsif !thing.present?
      # Do not allow clearing of type.
    else
      raise ActiveRecord::AssociationTypeMismatch.new('Expected Doogle::DisplayConfig, got ' + thing.class.name + ' ' + thing.to_s)
    end
  end

  def is_display_of?(dc)
    self.display_type.key == dc.key
  end

  # puts Display.unused_datasheets.join("\n")
  def self.unused_datasheets
    Dir.glob(Doogle::Engine.root + 'public/ds/*.pdf').select { |p| Display.count(:conditions => "data_sheet_path like '%#{File.basename(p)}'") == 0}
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
    case self.display_type.key
    when :glass_displays
      false
    when :module_displays
      self.lcd_type.include?('Graph')
    else
      true
    end
  end

  Doogle::FieldConfig.search_ranges.each do |field|
    active_hash_setter(field.search_range_class, field.search_range_attribute)
    self.class_eval <<-RUBY
    attr_accessor :#{field.search_range_attribute}_id
    scope '#{field.search_range_attribute}', lambda { |range|
      if range.exact?
        {
          :conditions => { '#{field.key}' => range.exact }
        }
      elsif range.no_max?
        {
          :conditions => [ 'displays.#{field.key} >= ?', range.min ]
        }
      elsif range.no_min?
        {
          :conditions => [ 'displays.#{field.key} <= ?', range.max ]
        }
      else
        {
          :conditions => [ 'displays.#{field.key} >= ? AND displays.#{field.key} <= ?', range.min, range.max ]
        }
      end
    }
    RUBY
  end

  def asset_public?(key)
    key = "#{key}_public"
    self.respond_to?(key) && self.send(key)
  end

  def web_sync!
    dr = if self.web_id
      Doogle::DisplayResource.find(self.web_id)
    else
      Doogle::DisplayResource.new
    end
    Doogle::FieldConfig.non_composites.each do |field|
      if field.web?
        if field.has_many?
          ids_method = field.column.to_s.singularize
          dr.send("#{ids_method}_ids=", self.send("#{ids_method}_ids"))
        elsif field.attachment?
          [:file_name, :content_type, :file_size, :updated_at].each do |paperclip_key|
            paperclip_column = "#{field.column}_#{paperclip_key}"
            dr.send("#{paperclip_column}=", self.send(paperclip_column))
          end
        else
          dr.send("#{field.column}=", self.send(field.column))
        end
      end
    end
    if dr.save
      self.web_id = dr.id
      if self.changed?
        self.save
      else
        true
      end
    else
      logger.error "Doogle::Display.web_sync! failed: " + dr.errors.full_messages.join("\n")
      false
    end
  end

  def self.web_sync
    self.web.each(&:web_sync!)
  end

  # rails console
  # Display.find_each { |d| d.guess_resolutions ; d.save if d.changed? }
  def guess_resolutions
    if !self.graphic_display?
      self.resolution_x ||= nil
      self.resolution_y ||= nil
    else
      search_attribute = if self.display_type.active_field?(:resolution)
        self._resolution
      elsif self.display_type.active_field?(:pixel_configuration)
        self._pixel_configuration
      elsif self.display_type.active_field?(:lcd_type)
        self._lcd_type
      end
      return unless search_attribute
      if search_attribute =~ /(\d+)[^\d]+(\d+)/
        self.resolution_x ||= $1
        self.resolution_y ||= $2
      end
    end
  end

  # rails console
  # Display.find_each { |d| d.guess_temperatures ; d.save if d.changed? }
  def guess_temperatures
    if self._storage_temperature =~ /(\d+)[^\d]+(\d+)/
      self.storage_temperature_min ||= $1
      self.storage_temperature_max ||= $2
    end
    if self._operational_temperature =~ /(\d+)[^\d]+(\d+)/
      self.operational_temperature_min ||= $1
      self.operational_temperature_max ||= $2
    end
  end

  MM_PER_INCH = 25.4
  MM_PRECISION = 4
  def guess_module_dimensions
    if self._diagonal_size.present? and !self._diagonal_size.include?('WIDE')
      self.module_diagonal_in = self._diagonal_size.to_f
    else
      self.module_diagonal_in = nil
    end
    numbers = nil
    if self._module_dimensions.present?
      numbers = self._module_dimensions.scan(/(?:\d+\.\d+)|(?:\d+)/)
    end
    if (numbers.nil? or (numbers.size <= 1)) and self._outline_dimensions.present?
      numbers = self._outline_dimensions.scan(/(?:\d+\.\d+)|(?:\d+)/)
    end
    if (numbers.nil? or (numbers.size <= 1)) and self._panel_size.present?
      numbers = self._panel_size.scan(/(?:\d+\.\d+)|(?:\d+)/)
    end
    if numbers and (numbers.size > 1)
      width = numbers[0].to_f
      height = numbers[1].to_f
      thickness = numbers[2].to_f
      is_in_inches = width <= 10
      doit = Proc.new { |n|
        if n == 0
          nil
        elsif is_in_inches
          (n * MM_PER_INCH).round(MM_PRECISION)
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

  def guess_viewing_area
    width = height = nil
    if self._viewing_dimensions.present? and (self._viewing_dimensions =~ /(\d+\.\d+)[^\d]+(\d+\.\d+)/)
      width = $1.to_f
      height = $2.to_f
      if width <= 10
        width = (width * MM_PER_INCH).round(MM_PRECISION)
        height = (height * MM_PER_INCH).round(MM_PRECISION)
      end
    end
    self.viewing_width_mm = width
    self.viewing_height_mm = height
  end

  def guess_bonding_type
    if (bt = read_attribute(:_bonding_type) and bt.present?) or (bt = self._configuration).present?
      self.bonding_type = Doogle::BondingType.find_by_name(bt[0..2])
    end
  end

  def guess_backlight_color
    if bc = read_attribute(:_backlight_color) and bc.present?
      self.backlight_color = Doogle::Color.find_by_name_or_alias(bc)
    end
  end

  def guess_graphic_type
    self.graphic_type = if (self.display_type.key == :glass_displays) or (self._lcd_type and self._lcd_type.include?('Char'))
      Doogle::GraphicType.character
    else
      Doogle::GraphicType.graphic
    end
  end

  def resolution_character
    if self.character_rows && self.character_columns
      "#{self.character_columns} x #{self.character_rows}"
    else
      nil
    end
  end

  def guess_character_resolutions
    columns = rows = nil
    if self._lcd_type.present? and self._lcd_type.include?('Char') and (self._lcd_type =~ /(\d+)[^\d]+(\d+)/)
      # Assume there are always more columns than rows.
      x = $1.to_f
      y = $2.to_f
      columns, rows = x > y ? [x, y] : [y, x]
    elsif self._number_of_digits.present? and ((num = self._number_of_digits.to_f) > 0)
      columns = num
      rows = 1.0
    end
    self.character_columns = columns
    self.character_rows = rows
  end

  def guess_luminance
    if self._brightness.present?
      self.luminance_nits ||= self._brightness.to_i
    end
  end

  def guess_pixel_color
    result = nil
    if self._technology_type.present?
      result = if self._technology_type.include?('Gray') or self._technology_type.include?('Grey')
        Doogle::Color.gray
      elsif self._technology_type.include?('Blue')
        Doogle::Color.blue
      elsif self._technology_type.include?('Y/G')
        Doogle::Color.yellow_green
      else
        nil
      end
    end
    self.pixel_color = result
  end

  def guess_display_mode
    result = nil
    if self._technology_type.present?
      # Go in reverse so that FSTN matches before TN.
      Doogle::DisplayMode.all.reverse.each do |tt|
        if self._technology_type.include?(tt.name)
          result = tt
          break
        end
      end
    end
    self.display_mode = result
  end

  def guess_display_image
    if (pm = read_attribute(:_polarizer_mode)) and pm.present?
      if pm == 'Pos'
        self.display_image = Doogle::DisplayImage.positive
      elsif pm == 'Neg'
        self.display_image = Doogle::DisplayImage.negative
      end
    end
  end

  def guess_polarizer_mode
    if (pm = read_attribute(:_polarizer_mode)) and pm.present?
      self.polarizer_mode = Doogle::PolarizerMode.all.detect { |p| p.name == pm }
    end
  end

  def guess_active_area
    width = height = nil
    if self._active_area.present? and (self._active_area =~ /(\d+\.\d+)[^\d]+(\d+\.\d+)/)
      width = $1.to_f
      height = $2.to_f
      if width <= 10
        width = (width * MM_PER_INCH).round(MM_PRECISION)
        height = (height * MM_PER_INCH).round(MM_PRECISION)
      end
    end
    self.active_area_width_mm = width
    self.active_area_height_mm = height
  end

  def guess_module_type
    result = nil
    if self._lcd_type.present?
      if self._lcd_type.include?('Char')
        result = 'character_module_displays'
      elsif self._lcd_type.include?('Graph')
        result = 'graphic_module_displays'
      end
    end
    if result
      self.type_key = result
    end
  end

  def guess_backlight_type
    result = nil
    if (btype = self.read_attribute(:_backlight_type)).present?
      Doogle::BacklightType.all.each do |bt|
        if btype.include?(bt.name)
          result = bt
          break
        end
      end
    end
    self.backlight_type = result
  end

  def guess_target_environment
    if self.display_type.key == :sunlight_tft_displays
      self.type_key = :tft_displays
      self.target_environment = Doogle::TargetEnvironment.sunlight_readable
    elsif self.display_type.key == :small_tft_displays
      self.type_key = :tft_displays
      self.target_environment = Doogle::TargetEnvironment.indoor
    elsif (self.display_type.key == :tft_displays) and self.target_environment.nil?
      self.target_environment = Doogle::TargetEnvironment.indoor
    end
  end

  def guess_viewing_direction
    result = nil
    if self._view_direction.present?
      result = if self._view_direction.include?('6')
        Doogle::ViewingDirection.six
      elsif self._view_direction.include?('12')
        Doogle::ViewingDirection.twelve
      end
    elsif self._viewing_angle.present?
      result = if self._viewing_angle == '6:00'
        Doogle::ViewingDirection.six
      elsif self._viewing_angle == '12:00'
        Doogle::ViewingDirection.twelve
      end
    end
    self.viewing_direction = result if result
  end

  def guess_total_power_consumption
    if self._power_consumption.present?
      self.total_power_consumption = self._power_consumption.to_f
    end
  end

  def guess_number_of_pins
    if self._number_of_pins.present?
      self.no_of_pins = self._number_of_pins.to_i
    end
  end

  def guess_contrast_ratio
    if self._contrast.present?
      self.contrast_ratio = self._contrast.to_i
    end
  end

  def guess_standard_classification
    self.standard_classification = Doogle::StandardClassification.standard_part
  end

  def guess_interface_types
    if self._interface.present?
      txt = self._interface.downcase
      self.interface_types = Doogle::InterfaceType.all.select { |it| txt.include?(it.name.downcase) }
    end
  end

  def guess_viewing_cone
    if self._viewing_angle.present? and !self._viewing_angle.include?(':')
      self.viewing_cone = self._viewing_angle.split(' ').first.to_i
    end
  end

  def guess_digit_height
    if self._digit_height.present?
      self.digit_height_mm = (self._digit_height.to_f * MM_PER_INCH).round(MM_PRECISION)
    end
  end

  # rails console
  # Doogle::Display.gr!
  def self.gr!
    find_each { |d| d.guess_ranges! }
  end
  def guess_ranges!
    self.guess_resolutions
    self.guess_temperatures
    self.guess_module_dimensions
    self.guess_bonding_type
    self.guess_backlight_color
    self.guess_character_resolutions
    self.guess_luminance
    self.guess_pixel_color
    self.guess_display_mode
    self.guess_viewing_area
    self.guess_display_image
    self.guess_polarizer_mode
    self.guess_active_area
    self.guess_module_type
    self.guess_backlight_type
    self.guess_target_environment
    self.guess_viewing_direction
    self.guess_total_power_consumption
    self.guess_number_of_pins
    self.guess_contrast_ratio
    self.guess_standard_classification
    self.publish_to_web = true
    self.publish_to_erp = true
    self.guess_interface_types
    self.guess_viewing_cone
    self.guess_digit_height
    self.save! if self.changed?
  end
end

Paperclip.interpolates :model_number do |attachment, style|
  attachment.instance.model_number
end

Paperclip.interpolates :display_type do |attachment, style|
  attachment.instance.display_type.key
end
