# == Schema Information
#
# Table name: displays
#
#  id                                 :integer          not null, primary key
#  type_key                           :string(255)
#  model_number                       :string(255)
#  integrated_controller              :string(255)
#  status_id                          :integer
#  creator_id                         :integer
#  updater_id                         :integer
#  created_at                         :datetime
#  updated_at                         :datetime
#  position                           :integer
#  colors                             :string(255)
#  source_model_number                :string(255)
#  datasheet_file_name                :string(255)
#  datasheet_content_type             :string(255)
#  datasheet_file_size                :integer
#  datasheet_updated_at               :datetime
#  touch_panel_type_id                :integer
#  timing_controller_type_id          :integer
#  specification_type_id              :integer
#  viewing_cone                       :integer
#  resolution_x                       :integer
#  resolution_y                       :integer
#  storage_temperature_min            :integer
#  storage_temperature_max            :integer
#  operational_temperature_min        :integer
#  operational_temperature_max        :integer
#  module_width_mm                    :decimal(12, 4)
#  module_height_mm                   :decimal(12, 4)
#  module_thickness_mm                :decimal(12, 4)
#  module_diagonal_in                 :decimal(12, 4)
#  bonding_type_id                    :integer
#  backlight_color_id                 :integer
#  graphic_type_id                    :integer
#  character_rows                     :decimal(12, 4)
#  character_columns                  :decimal(12, 4)
#  luminance_nits                     :integer
#  display_mode_id                    :integer
#  pixel_color_id                     :integer
#  display_image_id                   :integer
#  viewing_width_mm                   :decimal(12, 4)
#  viewing_height_mm                  :decimal(12, 4)
#  polarizer_mode_id                  :integer
#  character_type_id                  :integer
#  active_area_width_mm               :decimal(12, 4)
#  active_area_height_mm              :decimal(12, 4)
#  backlight_type_id                  :integer
#  interface_id                       :integer
#  icon_type_id                       :integer
#  comments                           :text
#  standard_classification_id         :integer
#  mask_type_id                       :integer
#  background_color_id                :integer
#  logic_operating_voltage            :decimal(12, 4)
#  target_environment_id              :integer
#  viewing_direction_id               :integer
#  digit_height_mm                    :decimal(12, 4)
#  total_power_consumption            :decimal(12, 4)
#  no_of_pins                         :integer
#  contrast_ratio                     :integer
#  field_of_view                      :integer
#  current_revision                   :boolean
#  revision                           :string(255)
#  approval_status_id                 :integer
#  publish_to_erp                     :boolean
#  erp_id                             :integer
#  publish_to_web                     :boolean
#  needs_pushed_to_web                :boolean
#  datasheet_public                   :boolean
#  source_specification_file_name     :string(255)
#  source_specification_content_type  :string(255)
#  source_specification_file_size     :integer
#  source_specification_updated_at    :datetime
#  specification_file_name            :string(255)
#  specification_content_type         :string(255)
#  specification_file_size            :integer
#  specification_updated_at           :datetime
#  specification_public               :boolean
#  drawing_file_name                  :string(255)
#  drawing_content_type               :string(255)
#  drawing_file_size                  :integer
#  drawing_updated_at                 :datetime
#  drawing_public                     :boolean
#  description                        :string(255)
#  gamma_required                     :boolean
#  multiplex_ratio                    :integer
#  previous_revision_id               :integer
#  original_customer_name             :string(255)
#  original_customer_part_number      :string(255)
#  tft_type_id                        :integer
#  on_master_list                     :boolean
#  display_component_vendor_name      :string(255)
#  display_component_model_number     :string(255)
#  touch_panel_component_vendor_name  :string(255)
#  touch_panel_component_model_number :string(255)
#  why                                :string(255)
#  original_xnumber                   :string(255)
#  ctp_ic                             :string(255)
#

# tim@concerto:~/Dropbox/p/lxd_m2mhub$ bundle exec annotate --model-dir ../doogle/app/models
#

require 'plutolib/active_hash_setter'
require 'acts_as_list'
require 'doogle/web_synchronizer'

class Doogle::Display < ApplicationModel
  validates_uniqueness_of :model_number
  validates_presence_of :type_key, :status

  include Plutolib::ActiveHashSetter
  active_hash_setter(Doogle::Status)
  active_hash_setter(Doogle::TouchPanelType)
  active_hash_setter(Doogle::BondingType)
  active_hash_setter(Doogle::Color, :backlight_color)
  active_hash_setter(Doogle::Color, :pixel_color)
  active_hash_setter(Doogle::Color, :background_color)
  active_hash_setter(Doogle::DisplayMode)
  active_hash_setter(Doogle::DisplayImage)
  active_hash_setter(Doogle::PolarizerMode)
  active_hash_setter(Doogle::CharacterType)
  active_hash_setter(Doogle::BacklightType)
  active_hash_setter(Doogle::TargetEnvironment)
  active_hash_setter(Doogle::ViewingDirection)
  active_hash_setter(Doogle::IconType)
  active_hash_setter(Doogle::MaskType)
  active_hash_setter(Doogle::StandardClassification)
  active_hash_setter(Doogle::TftType)
  has_many :display_interface_types, :class_name => 'Doogle::DisplayInterfaceType', :dependent => :destroy
  has_many :interface_types, :through => :display_interface_types, :source => :interface_type
  belongs_to :item, :class_name => 'M2m::Item', :foreign_key => 'erp_id'
  belongs_to :previous_revision, :class_name => 'Doogle::Display', :foreign_key => 'previous_revision_id'
  has_many :spec_versions, :class_name => 'Doogle::SpecVersion', :dependent => :destroy
  has_many :prices, :class_name => 'Doogle::DisplayPrice', :dependent => :destroy
  has_many :logs, :class_name => 'Doogle::DisplayLog'

if Rails::VERSION::MAJOR < 5
  def next_revision
    Doogle::Display.not_deleted.find_by_previous_revision_id(self.id)
  end
else
  has_one :next_revision, lambda { where('displays.status_id != ?', Doogle::Status.deleted.id) }, :class_name => 'Doogle::Display', :foreign_key => 'previous_revision_id'
end

  # [ [:datasheet, ':display_type/:model_number/LXD-:model_number-datasheet.:extension'],
  #   [:specification, ':display_type/:model_number/LXD-:model_number-spec.:extension'],
  #   [:source_specification, ':display_type/:model_number/non-public-:model_number-spec.:extension'],
  #   [:drawing, ':display_type/:model_number/LXD-:model_number-drawing-:style.:extension', {:thumbnail => '100>', :medium => '400>', :large => '600>'}]
  # ].each do |key, path, image_styles|
  #   options = { :storage => :s3,
  #               :s3_credentials => { :access_key_id => AppConfig.doogle_access_key_id,
  #                                    :secret_access_key => AppConfig.doogle_secret_access_key },
  #               :url => ':s3_is_my_bitch_url',
  #               :bucket => AppConfig.doogle_bucket,
  #               :s3_permissions => 'authenticated-read',
  #               :path => path,
  #               :asset_key => key }
  #   options[:styles] = image_styles if image_styles
  #   has_attached_file key, options
  # end

  def original_opportunity
    if self.original_xnumber.present?
      Sales::Opportunity.xnumber(self.original_xnumber).first
    else
      nil
    end
  end

  def model_number_without_rev
    if self.model_number =~ /^([A-Z]+\d+)[A-Z]+$/
      $1
    else
      self.model_number
    end
  end
  def demo_items
    M2m::Item.part_number_like(self.model_number_without_rev + '%DEMO').all + M2m::Item.part_number_like(self.model_number_without_rev + '%ADBOARD').all
  end

  acts_as_list
  def scope_condition
    "type_key = '#{type_key}'"
  end

  scope :not_deleted, lambda { where(['displays.status_id != ?', Doogle::Status.deleted.id]) }
  scope :published, lambda { where(['displays.status_id = ?', Doogle::Status.published.id]) }
  scope :draft, lambda { where(['displays.status_id = ?', Doogle::Status.draft.id]) }
  scope :display_type, lambda { |*types|
    type_keys = types.flatten.map { |t| t.is_a?(Doogle::DisplayConfig) ? t.key.to_s : t.to_s }
    if type_keys.include?('any')
      where({})
    else
      where('displays.type_key in (?)', type_keys)
    end
  }
  %w(multiplex_ratio resolution_x resolution_y type_key gamma_required).each do |key|
    scope key, lambda { |v| where(key => v) }
  end
  scope :for_model, lambda { |model_number| where(:model_number => model_number) }
  scope :by_model_number, lambda { order(:model_number) }
  scope :by_resolution, lambda { order([:resolution_x, :resolution_y]) }
  scope :interface_types, lambda { |itypes|
    joins(:display_interface_types).where('display_interface_types.interface_type_id in (?)', itypes.map(&:id))
  }
  %w(why comments description colors source_model_number integrated_controller original_customer_name original_customer_part_number original_xnumber ctp_ic).each do |key|
    scope key, lambda { |text| where("displays.#{key} ilike ?", '%' + (text.strip || '') + '%') }
  end

  scope :model_number, lambda { |txt|
    model_numbers = txt.split(/[ ,]/).select(&:present?).map { |m| "%#{m.strip}%" }
    where(model_numbers.map { |m| 'displays.model_number ilike ?' }.join(' OR '), *model_numbers)
  }

  scope :web, lambda { where(:publish_to_web => true) }
  %w(datasheet_public publish_to_web publish_to_erp).each do |key|
    self.class_eval <<-RUBY
      scope :#{key}, lambda { |v| where(:#{key} => v) }
    RUBY
  end
  active_hash_setter(Doogle::StatusOption, :status_option)
  attr_accessor :status_option_id
  scope :status_option, lambda { |status_option|
    where('displays.status_id in (?)', status_option.status_ids)
  }
  # active_hash_setter(Doogle::TftDiagonalInOption, :tft_diagonal_in_option)
  attr_accessor :tft_diagonal_in_option_id
  scope :tft_diagonal_in_option, lambda { |option|
    where(:module_diagonal_in => option.value)
  }
  def tft_diagonal_in_option
    Doogle::TftDiagonalInOption.from_diagonal(self.tft_diagonal_in_option_id)
  end
  attr_accessor :oled_diagonal_in_option_id
  scope :oled_diagonal_in_option, lambda { |option|
    where(:module_diagonal_in => option.value)
  }
  def oled_diagonal_in_option
    Doogle::OledDiagonalInOption.from_diagonal(self.oled_diagonal_in_option_id)
  end
  def viewing_area_diagonal
    if self.viewing_height_mm and self.viewing_width_mm
      Math.sqrt(self.viewing_height_mm * self.viewing_height_mm + self.viewing_width_mm * self.viewing_width_mm) / 25.4
    else
      nil
    end
  end

  scope :standard, lambda { where(:standard_classification_id => Doogle::StandardClassification.standard.id) }
  scope :on_master_list, lambda { where(:on_master_list => true) }

  attr_accessor :search_vendor_id
  # def vendor
  #   self.vendor_id
  # end
  scope :search_vendor, lambda { |vendor_id|
    if vendor_id =~ /^\d+$/
      where('displays.id in (select distinct display_id from display_prices where m2m_vendor_id = ?)', vendor_id)
    else
      where('displays.id in (select distinct display_id from display_prices where vendor_name = ?)', vendor_id)
    end
  }

  def self.display_component_vendor_name(vendor_name)
    where(:display_component_vendor_name => vendor_name)
  end
  def self.display_component_model_number(model_number)
    where(:display_component_model_number => model_number)
  end
  def self.touch_panel_component_vendor_name(vendor_name)
    where(:touch_panel_component_vendor_name => vendor_name)
  end
  def self.touch_panel_component_model_number(model_number)
    where(:touch_panel_component_model_number => model_number)
  end
  # def self.set_default_component_vendor_names
  #   self.display_type(:tft_displays).all.each do |d|
  #     if txt = d.preferred_vendor.try(:vendor_name)
  #       d.display_component_vendor_name = txt
  #       d.save! if d.changed?
  #     end
  #   end
  #   true
  # end

  attr_accessor :vendor_part_number
  scope :vendor_part_number, lambda { |txt|
    vendor_part_numbers = txt.split(/[ ,]/).select(&:present?).map { |m| "%#{m.strip}%" }
    conditions = vendor_part_numbers.map { |m| 'vendor_part_number ilike ?' }.join(' OR ')
    where(["displays.id in (select distinct display_id from display_prices where #{conditions})", *vendor_part_numbers])
  }

  attr_accessor :sql_query
  scope :sql_query, lambda { |txt|
    where(txt)
  }

  def self.without_displays(displays)
    where ['displays.id not in (?)', displays.map(&:id)]
  end
  def self.created_after(date)
    where ['displays.created_at > ?', date]
  end
  def self.no_of_pins(numpins)
    where :no_of_pins => numpins.to_i
  end

  def search_field_specified?(field)
    value = self.send(field.search_value_key)
    value.present? || value.is_a?(FalseClass)
  end
  def search_scope(display_scope, field)
    display_scope.send(field.search_scope_key, self.send(field.search_value_key))
  end

  def destroy
    self.update_attributes(:status_id => Doogle::Status.deleted.id)
  end

  def model_and_id
    "id: #{id} #{model_number}"
  end

  def clean_decimal(thing, nil_if_equals=nil)
    if thing and (thing.to_f != nil_if_equals)
      if (thing.is_a?(Float) or thing.is_a?(BigDecimal)) and (thing.to_i == thing)
        thing = sprintf('%0.f', thing)
      end
      thing
    else
      nil
    end
  end

  def default_description
    self.instance_eval '"' + self.display_type.default_description + '"'
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
        where('#{field.key}' => range.exact)
      elsif range.no_max?
        where('displays.#{field.key} >= ?', range.min)
      elsif range.no_min?
        where('displays.#{field.key} <= ?', range.max)
      else
        where('displays.#{field.key} >= ? AND displays.#{field.key} <= ?', range.min, range.max)
      end
    }
    RUBY
  end

  def publish!
    return false if self.status.deleted?
    self.status = Doogle::Status.published
    self.save!
  end

  def maybe_sync_to_web
    # Ignore draft changes.  Deletes and publishes go live.
    if !self.status.draft?
      Doogle::WebSynchronizer.new(self.id).run_in_background!
    else
      false
    end
  end

  def sync_to_web
    dr = nil
    begin
      dr = Doogle::DisplayResource.find(self.id)
    rescue ActiveResource::ResourceNotFound
    end
    if dr.nil? and (self.status.nil? or !self.status.published?)
      # It's not on the web and it's not published, so exit.
      return
    end
    result = nil
    if !self.publish_to_web or self.status.deleted?
      result = if dr.present? and !dr.status.try(:deleted?)
        dr.destroy
        :delete
      else
        :no_change
      end
    else
      dr ||= Doogle::DisplayResource.new(:new_display_id => self.id)
      Doogle::FieldConfig.non_composites.each do |field|
        if field.web?
          if field.has_many?
            ids_method = field.render_value_key.to_s.singularize
            dr.send("#{ids_method}_ids=", self.send("#{ids_method}_ids"))
          elsif !field.attachment?
            # Avoid sending empty string (which will end up being different from nil).
            if (!dr.respond_to?(field.db_value_key) or !dr.send(field.db_value_key).present?) and !self.send(field.db_value_key).present?
              # Do nothing
            else
              dr.attributes[field.db_value_key] = self.send(field.db_value_key)
            end
          end
        end
      end
      success_result = dr.new_record? ? :create : :update
      result = dr.save ? success_result : :error
    end
    Doogle::DisplayLog.create(:display => self, :summary => 'Web Sync', :details => "result = #{result}")
    if (result == :create) and self.previous_revision.present?
      self.previous_revision.destroy # should already be destroyed
      self.previous_revision.sync_to_web
    end
    self.latest_spec.try(:synchronous_sync_to_web)
    result
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

  def sync_to_erp!
    if self.item.nil? and (item = M2m::Item.with_part_number(self.model_number).first)
      self.item = item
      self.save! if self.changed?
    end
    true
  end

  def self.sync_all_to_erp
    Doogle::Display.where(:erp_id => nil).each(&:sync_to_erp!)
    true
  end

  def deprecated_sync_to_erp
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
      { :fpartno => self.model_number, :location => 'WAREHOUSE', :description => self.description || self.display_type.name, :product_class_key => product_class_number, :group_code_key => self.display_type.m2m_group_code, :frev => '000', :fsource => M2m::ItemSource.buy.key, :abc_code => 'A', :fac => 'Default', :sfac => 'Default', :fcstscode => 'A', :fcstperinv => 1.0, :fbulkissue => 'Y', :fcbackflsh => 'N', :fcopymemo => 'Y', :fcostcode => 'R', :fcpurchase => 'Y', :fdrawno => self.model_number, :finspect => 'N', :fyield => 100.0, :fcudrev => '000', :flFSRtn => 1, :flocbfdef => 'WAREHOUSE', :measure1 => 'EA', :measure2 => 'EA' }.each do |key, value|
        item.send("#{key}=", value)
      end
      unless item.save
        item.errors.each do |error|
          self.errors.add_to_base error.message
        end
      end
      self.erp_id = item.id
    end
    self.save
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

  def has_revision_letter?
    if self.model_number[self.model_number.size-1, self.model_number.size-1] =~ /[A-Z]/
      true
    else
      false
    end
  end

  def latest_revision
    if @latest_revision.nil?
      @latest_revision = self
      d = self
      while d
        if d = Doogle::Display.where(:previous_revision_id => d.id).first
          @latest_revision = d
        end
      end
    end
    @latest_revision
  end

  def latest_revision?
    self.latest_revision == self
  end

  def latest_spec
    if @latest_spec_set.nil?
      @latest_spec = self.spec_versions.by_version_desc.latest.first
      @latest_spec_set = true
    end
    @latest_spec
  end
  def latest_spec=(val)
    @latest_spec_set = true
    @latest_spec = val
  end

  # updated = []
  # Doogle::Display.where(:previous_revision_id => nil).each { |d| updated.push d if d.choose_previous_revision! } ; updated.size
  # puts updated.map { |d| "#{d.previous_revision.model_number} <= #{d.model_number}" }.join("\n")
  def choose_previous_revision!
    return false if self.previous_revision_id.present?
    # Only assign for model numbers ending in letter.
    return false unless self.has_revision_letter? && (self.model_number.size == 6)
    if self.previous_revision = Doogle::Display.where(['displays.model_number like ? and displays.id != ? and displays.model_number < ?', self.model_number[0..self.model_number.size-2] + '%', self.id, self.model_number]).order('displays.model_number desc').first
      self.save!
      true
    else
      false
    end
  end

  # Returns all revisions (connected via previous_revision_id) in order.
  def all_revisions
    result = []
    display_id = self.id
    while display_id
      if display = Doogle::Display.find_by_previous_revision_id(display_id)
        result.push display
        display_id = display.id
      else
        display_id = nil
      end
    end
    result.unshift self
    display = self.previous_revision
    while display
      result.unshift display
      display = display.previous_revision
    end
    result
  end

  def web_sort_key
    case self.type_key
    when 'tft_displays'
      [(self.module_diagonal_in || '99999').to_f, self.model_number]
    when 'character_module_displays'
      [self.character_columns || 0, self.character_rows || 0, self.model_number]
    when 'graphic_module_displays'
      [self.resolution_x || 0, self.resolution_y || 0, self.model_number]
    when 'segment_glass_displays'
      [self.character_columns || 0, self.model_number]
    when 'graphic_glass_displays'
      [self.resolution_x || 0, self.resolution_y || 0, self.model_number]
    when 'oled_displays'
      [(self.module_diagonal_in || '99999').to_f, self.model_number]
    else
      self.model_number
    end
  end

  def attachment_fields
    self.display_type.attachment_fields
  end

  def vendors
    @vendors ||= self.prices.vendors.map { |p| Doogle::DisplayVendor.new(p) }
  end

  def latest_vendors
    if @latest_vendors.nil?
      @latest_vendors = []
      self.vendors.group_by(&:vendor_name).each do |vendor_name, vendors|
        if vendor_name.present?
          @latest_vendors.push vendors.max_by(&:last_date)
        end
      end
    end
    @latest_vendors
  end

  def preferred_vendor_price(date=nil)
    self.prices.active_on(date || Date.current).all.select(&:preferred_vendor).first
  end

  def preferred_vendor(date=nil)
    if p = self.preferred_vendor_price(date)
      Doogle::DisplayVendor.new(p)
    else
      nil
    end
  end

  protected

    after_create :log_create
    def log_create
      Doogle::DisplayLog.create(:display => self,
                                :user_id => current_user.try(:id),
                                :summary => 'Create',
                                :details => Doogle::Display.inspect_changes(self.changes),
                                :log_type_id => Doogle::LogType.create.id)
    end
    before_destroy :log_destroy
    def log_destroy
      Doogle::DisplayLog.create(:display => self,
                                :user_id => current_user.try(:id),
                                :summary => 'Destroy',
                                :log_type_id => Doogle::LogType.destroy.id)
    end
    before_update :log_update
    def log_update
      Doogle::DisplayLog.create(:display => self,
                                :user_id => current_user.try(:id),
                                :summary => 'Update',
                                :details => Doogle::Display.inspect_changes(self.changes),
                                :log_type_id => Doogle::LogType.update.id)
    end

    def self.inspect_changes(changes)
      details = []
      changes.each do |attribute, change|
        next if ['created_at', 'updated_at'].include?(attribute)
        old_value, new_value = change
        details.push "#{attribute}: #{old_value} => #{new_value}"
      end
      details.join("\n")
    end
end
