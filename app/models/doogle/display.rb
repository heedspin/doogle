# == Schema Information
#
# Table name: displays
#
#  id                                :integer(4)      not null, primary key
#  type_key                          :string(255)
#  model_number                      :string(255)
#  integrated_controller             :string(255)
#  status_id                         :integer(4)
#  creator_id                        :integer(4)
#  updater_id                        :integer(4)
#  created_at                        :datetime
#  updated_at                        :datetime
#  position                          :integer(4)
#  colors                            :string(255)
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
#  description                       :string(255)
#  gamma_required                    :boolean(1)
#  multiplex_ratio                   :integer(4)
#

# tim@concerto:~/Dropbox/p/lxd_m2mhub$ bundle exec annotate --model-dir ../doogle/app/models
#

require 'active_hash_setter'
require 'acts_as_list'
require 'doogle/web_synchronizer'

class Doogle::Display < ApplicationModel
  validates_uniqueness_of :model_number
  validates_uniqueness_of :source_model_number, :allow_blank => true
  validates_presence_of :type_key, :status

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
  belongs_to :item, :class_name => 'M2m::Item', :foreign_key => 'erp_id'

  [ [:datasheet, ':display_type/:model_number/LXD-:model_number-datasheet.:extension'],
    [:specification, ':display_type/:model_number/LXD-:model_number-spec.:extension'],
    [:source_specification, ':display_type/:model_number/non-public-:model_number-spec.:extension'],
    [:drawing, ':display_type/:model_number/LXD-:model_number-drawing-:style.:extension', {:thumbnail => '100>', :medium => '400>', :large => '600>'}]
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
  %w(multiplex_ratio resolution_x resolution_y type_key gamma_required).each do |key|
    scope key, lambda { |v|
      {
        :conditions => { key => v }
      }
    }
  end
  scope :for_model, lambda { |model_number|
    {
      :conditions => { :model_number => model_number }
    }
  }
  scope :by_model_number, :order => :model_number
  scope :by_resolution, :order => [ :resolution_x, :resolution_y ]
  scope :interface_types, lambda { |itypes|
    {
      :joins => :display_interface_types,
      :conditions => [ 'display_interface_types.interface_type_id in (?)', itypes.map(&:id) ]
    }
  }
  %w(comments description colors source_model_number integrated_controller model_number).each do |key|
    scope key, lambda { |text|
      {
        :conditions => [ "LOWER(displays.#{key}) like ?", '%' + (text.strip.downcase || '') + '%' ]
      }
    }
  end
  
  scope :web, :conditions => { :publish_to_web => true }
  %w(datasheet_public publish_to_web publish_to_erp).each do |key|
    self.class_eval <<-RUBY
    scope :#{key}, lambda { |v|
    {
      :conditions => { :#{key} => v } }
    }
    RUBY
  end
  active_hash_setter(Doogle::StatusOption, :status_option)
  attr_accessor :status_option_id
  scope :status_option, lambda { |status_option|
    {
      :conditions => [ 'displays.status_id in (?)', status_option.status_ids ]
    }
  }
  # active_hash_setter(Doogle::TftDiagonalInOption, :tft_diagonal_in_option)
  attr_accessor :tft_diagonal_in_option_id
  scope :tft_diagonal_in_option, lambda { |option|
    {
      :conditions => { :module_diagonal_in => option.value }
    }
  }
  def tft_diagonal_in_option
    Doogle::TftDiagonalInOption.from_diagonal(self.tft_diagonal_in_option_id)
  end
  attr_accessor :oled_diagonal_in_option_id
  scope :oled_diagonal_in_option, lambda { |option|
    {
      :conditions => { :module_diagonal_in => option.value }
    }
  }
  def oled_diagonal_in_option
    Doogle::OledDiagonalInOption.from_diagonal(self.oled_diagonal_in_option_id)
  end
  scope :display_type, lambda { |dt|
    if dt.key == :any
      where({})
    else
      {
        :conditions => { :type_key => dt.key.to_s }
      }
    end
  }
  
  def search_field_specified?(field)
    value = self.send(field.search_key)
    value.present? || value.is_a?(FalseClass)
  end
  def search_scope(display_scope, field)
    display_scope.send(field.search_key, self.send(field.search_key))
  end

  def destroy
    self.update_attributes(:status_id => Doogle::Status.deleted.id)
  end

  def model_and_id
    "id: #{id} #{model_number}"
  end

  # **********************************

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

  def graphic_display?
    case self.display_type.key
    when :character_module_displays, :glass_displays
      false
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

  def maybe_sync_to_web
    # Ignore draft changes.  Deletes and publishes go live.
    if !self.status.draft?
      Doogle::WebSynchronizer.new(self.id).run_in_background!
    end
  end

  def sync_to_web
    dr = nil
    begin
      dr = Doogle::DisplayResource.authorized_find(self.id)
    rescue ActiveResource::ResourceNotFound
    end
    return if dr.nil? and (self.status.nil? or !self.status.published?)
    if !self.publish_to_web
      if dr.present?
        dr.destroy
        :delete
      else
        :no_change
      end
    else
      dr ||= Doogle::DisplayResource.new(:new_display_id => self.id)
      Doogle::FieldConfig.non_composites.each do |field|
        if field.sync_to_web?
          if field.has_many?
            ids_method = field.column.to_s.singularize
            dr.send("#{ids_method}_ids=", self.send("#{ids_method}_ids"))
          elsif field.attachment?
            [:file_name, :content_type, :file_size, :updated_at].each do |paperclip_key|
              paperclip_column = "#{field.column}_#{paperclip_key}"
              dr.send("#{paperclip_column}=", self.send(paperclip_column))
            end
          else
            # Avoid sending empty string (which will end up being different from nil).
            if (!dr.respond_to?(field.column) or !dr.send(field.column).present?) and !self.send(field.column).present?
              # Do nothing
            else
              dr.attributes[field.column] =self.send(field.column)
            end
          end
        end
      end
      success_result = dr.new_record? ? :create : :update
      dr.save ? success_result : :error
    end
  end

  def sync_from_erp!(item)
    @in_sync_from_erp = true
    begin
      self.item = item
      self.model_number = item.part_number
      self.save!
    ensure
      @in_sync_from_erp = false
    end
  end

  def sync_to_erp
    return unless self.publish_to_erp
    product_class_number = M2m::ProductClass.with_name(self.display_type.m2m_product_class).first.try(:number) || (raise "No m2m product class for display type #{self.display_type.key} with name #{self.display_type.m2m_product_class}")
    if item = self.item
      item.product_class_key = product_class_number
      unless item.group_code_key.strip == self.display_type.m2m_group_code
        # Trailing whitespace lead to unnecessary updates.
        item.group_code_key = self.display_type.m2m_group_code
      end
      if item.changed?
        unless item.save
          item.errors.each do |error|
            self.errors.add_to_base error.message
          end
          return false
        end
      end
    elsif item = M2m::Item.with_part_number(self.model_number).first
      self.item = item
    else
      item = M2m::Item.new
      item.part_number = self.model_number
      item.revision = ''
      item.location = 'WAREHOUSE'
      item.description = self.description
      item.product_class_key = product_class_number
      item.group_code_key = self.display_type.m2m_group_code
      item.measure1 = item.measure2 = 'EA'
      item.source = M2m::ItemSource.buy
      item.abc_code = 'A'
      unless item.save
        item.errors.each do |error|
          self.errors.add_to_base error.message
        end
      end
      self.erp_id = item.id
    end
    true
  end

  # attr_accessor :m2m_validations
  #
  # validate :model_number_unique_in_erp, :on => :create
  # def model_number_unique_in_erp
  #   return unless self.m2m_validations
  #   if item = M2m::Item.with_part_number(self.model_number)
  #     errors.add(:model_number, "m2m part #{self.model_number} already exists")
  #   end
  # end

  # MM_PER_INCH = 25.4
  # MM_PRECISION = 4
  # 
  # Diagonal via Pythagorian:
  # Math.sqrt(self.module_width_mm * self.module_width_mm + self.module_height_mm * self.module_height_mm) / MM_PER_INCH
  # 
  # Inches to MM:
  # (n * MM_PER_INCH).round(MM_PRECISION)

  def forget_attachments
    %w(datasheet_public datasheet_updated_at datasheet_file_size datasheet_content_type datasheet_file_name source_specification_updated_at source_specification_file_size source_specification_content_type source_specification_file_name specification_public specification_updated_at specification_file_size specification_content_type specification_file_name drawing_public drawing_updated_at drawing_file_size drawing_content_type drawing_file_name).each do |field|
      write_attribute(field, nil)
    end
  end

  attr_accessor :current_user

  protected

    after_create :log_create
    def log_create
      Doogle::DisplayLog.create(:display => self, :user_id => current_user.try(:id), :summary => 'Create', :details => "status = #{self.status.name}")
    end
    before_destroy :log_destroy
    def log_destroy
      Doogle::DisplayLog.create(:display => self, :user_id => current_user.try(:id), :summary => 'Destroy')
    end
    before_update :log_update
    def log_update
      filtered_changes = self.changes.clone
      filtered_changes.delete('created_at')
      filtered_changes.delete('updated_at')
      Doogle::DisplayLog.create(:display => self,
                                :user_id => current_user.try(:id),
                                :summary => 'Update',
                                :details => filtered_changes.inspect)
    end
end

Paperclip.interpolates :model_number do |attachment, style|
  attachment.instance.model_number
end

Paperclip.interpolates :display_type do |attachment, style|
  attachment.instance.display_type.key
end
