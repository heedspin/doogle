# == Schema Information
#
# Table name: display_prices
#
#  id                 :integer          not null, primary key
#  display_id         :integer
#  m2m_vendor_id      :string(255)
#  vendor_name        :string(255)
#  vendor_part_number :string(255)
#  preferred_vendor   :boolean
#  start_date         :date
#  last_date          :date
#  quantity1          :integer
#  cost1              :decimal(12, 2)
#  price1             :decimal(12, 2)
#  quantity2          :integer
#  cost2              :decimal(12, 2)
#  price2             :decimal(12, 2)
#  quantity3          :integer
#  cost3              :decimal(12, 2)
#  price3             :decimal(12, 2)
#  quantity4          :integer
#  cost4              :decimal(12, 2)
#  price4             :decimal(12, 2)
#  quantity5          :integer
#  cost5              :decimal(12, 2)
#  price5             :decimal(12, 2)
#  quantity6          :integer
#  cost6              :decimal(12, 2)
#  price6             :decimal(12, 2)
#  quantity7          :integer
#  cost7              :decimal(12, 2)
#  price7             :decimal(12, 2)
#  quantity8          :integer
#  cost8              :decimal(12, 2)
#  price8             :decimal(12, 2)
#  import_token       :string(255)
#  notes              :text
#  created_at         :datetime
#  updated_at         :datetime
#  vendor_revision    :string(255)
#

require 'plutolib/logger_utils'

class Doogle::DisplayPrice < Doogle::Base
  include Plutolib::LoggerUtils
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :m2m_vendor, :class_name => 'M2m::Vendor', :primary_key => 'fvendno'
  validates_presence_of :start_date, :display, :vendor_name

  scope :by_start_date_desc, :order => 'display_prices.start_date desc'
  scope :display, lambda { |display|
    where(:display_id => display.id)
  }
  scope :import_token, lambda { |import_token|
    where(:import_token => import_token)
  }
  scope :active_on, lambda { |date|
    where(['display_prices.start_date <= ? and (display_prices.last_date >= ? or display_prices.last_date is null)', date, date])
  }
  scope :vendors, :select => [:vendor_name, :m2m_vendor_id, :vendor_part_number], :group => [:vendor_name, :m2m_vendor_id, :vendor_part_number]
  def self.vendor_part_number_like(pn)
    where(['display_prices.vendor_part_number like ?', "%#{pn}%"])
  end
  scope :not_deleted, includes(:display).where(['displays.status_id != ?', Doogle::Status.deleted.id])
  def self.created_after(date)
    includes(:display).where(['displays.created_at > ?', date])
  end
  def self.without_displays(displays)
    includes(:display).where(['displays.id not in (?)', displays.map(&:id)])
  end
  scope :active, where('display_prices.last_date is null')

  def self.uniq_vendor_names_like(txt)
    results = connection.select_rows <<-SQL
      select distinct(display_prices.vendor_name) from display_prices 
      where display_prices.vendor_name like '%#{txt}%'
      order by display_prices.vendor_name
      limit 20
    SQL
    results.map(&:first)
  end
  
  def vendor_part_number_and_revision
    [self.vendor_part_number, self.vendor_revision].select(&:present?).join(' &mdash; ').html_safe
  end

  after_save :unset_preferred_vendor
  def unset_preferred_vendor
    if self.preferred_vendor
      Doogle::DisplayPrice.update_all({:preferred_vendor => false}, ['display_prices.display_id = ? and display_prices.id != ? and display_prices.preferred_vendor = true', self.display_id, self.id])
    end
    true
  end

  before_save :set_m2m_vendor
  def set_m2m_vendor
    if self.vendor_name.present? and (self.m2m_vendor_id.nil? or self.m2m_vendor.nil? or (self.m2m_vendor.name != self.vendor_name))
      self.m2m_vendor = M2m::Vendor.with_name(self.vendor_name).first
    end
    true
  end

  after_save :set_last_dates
  def set_last_dates
    if self.last_date
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["display_prices.id != ? and display_prices.display_id = ? and display_prices.last_date is null and display_prices.start_date < ? and display_prices.vendor_name = ?", self.id, self.display_id, self.last_date, self.vendor_name])
    else
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["display_prices.id != ? and display_prices.display_id = ? and display_prices.last_date is null and display_prices.vendor_name = ?", self.id, self.display_id, self.vendor_name])
    end
    true
  end

  after_create :set_display_default_display_component_vendor
  def set_display_default_display_component_vendor
    if self.vendor_name.present? and self.display.display_component_vendor_name.blank?
      if self.display.update_attributes(:display_component_vendor_name => self.vendor_name)
        logger.info "Set #{self.display.model_number} display component vendor name to #{self.vendor_name}"
      else
        logger.info "Failed to set #{self.display.model_number} display component vendor name to #{self.vendor_name}"
      end
    end
    true
  end

  after_create :log_create
  def log_create
    Doogle::DisplayLog.create(:display => self.display,
                              :user_id => self.current_user.try(:id),
                              :summary => 'Created Vendor',
                              :details => Doogle::Display.inspect_changes(self.changes),
                              :log_type_id => Doogle::LogType.vendor.id)
    true
  end
  attr_accessor :current_user
  before_destroy :log_destroy
  def log_destroy
    Doogle::DisplayLog.create(:display => self.display,
                              :user_id => self.current_user.try(:id),
                              :summary => 'Destroyed Vendor',
                              :log_type_id => Doogle::LogType.vendor.id)
    true
  end
  before_update :log_update
  def log_update
    Doogle::DisplayLog.create(:display => self.display,
                              :user_id => self.current_user.try(:id),
                              :summary => 'Updated Vendor',
                              :details => Doogle::Display.inspect_changes(self.changes),
                              :log_type_id => Doogle::LogType.vendor.id)
    true
  end

  def same_as?(price)
    (1..TOTAL_LEVELS).each do |x|
      %w(quantity cost price).each do |key|
        return false unless (self.send("#{key}#{x}") == price.send("#{key}#{x}"))
      end
    end
    true
  end

  # validate :check_source_model_number
  # def check_source_model_number
  #   return unless self.source_model_number.present?
  #   conflicts = Doogle::Display.where(:source_model_number => self.source_model_number)
  #   unless self.new_record?
  #     conflicts = conflicts.scoped(:conditions => "displays.id != #{self.id}")
  #   end
  #   if self.previous_revision_id.nil?
  #     if conflicts.size > 0
  #       self.errors.add(:source_model_number, "Conflicts with: #{conflicts.map(&:model_number).join(', ')}")
  #     end
  #   else
  #     conflicts = conflicts.all
  #     unless (conflicts.size == 0) or (conflicts.any? { |c| c.id == self.previous_revision_id })
  #       self.errors.add(:source_model_number, "Conflicts with: #{conflicts.map(&:model_number).join(', ')}")
  #     end
  #   end
  # end

  def self.clone_price(source_price, source_display, destination_display)
    price = source_price.dup
    price.display_id = destination_display.id
    price.notes = "Cloned from #{source_display.model_number}"
    price.save!
    price
  end

  TOTAL_LEVELS=8
  def levels
    @levels ||= (1..TOTAL_LEVELS).map { |x| Doogle::PriceLevel.new(x, self) }
  end
  def levels_used
    self.levels.select(&:used?)
  end
  def clear_levels
    (1..TOTAL_LEVELS).each do |x|
      self.send("quantity#{x}=", nil)
      self.send("cost#{x}=", nil)
      self.send("price#{x}=", nil)
    end
    @levels = []
  end
  def next_level
    if @levels.size == TOTAL_LEVELS
      raise "Out of room!"
    end
    level = Doogle::PriceLevel.new(@levels.size + 1, self)
    @levels.push level
    level
  end
  def set_next_level(quantity, cost, price=nil)
    level = self.next_level
    level.quantity = quantity
    level.cost = cost
    level.price = price
    level
  end

  def self.set_preferred_vendors
    Doogle::Display.all.each do |display|
      if price = display.prices.order('display_prices.id desc').first
        if price.update_column(:preferred_vendor, true)
          puts "Set preferred vendor for #{display.model_number}"
        else
          puts "Failed to set preferred vendor for #{display.model_number}"
        end
      else
        puts "No pricing for #{display.model_number}"
      end
    end
    true
  end

  # def self.choose_vendor(display)
  #   @jiya ||= Doogle::DisplayVendor.id_for_short_name('Jiya')
  #   @jiyalf ||= Doogle::DisplayVendor.id_for_short_name('Jiya LF')
  #   @mit ||= Doogle::DisplayVendor.id_for_short_name('MIT')
  #   @nely ||= Doogle::DisplayVendor.id_for_short_name('Nely')
  #   @innolux ||= Doogle::DisplayVendor.id_for_short_name('Innolux')
  #   @wise ||= Doogle::DisplayVendor.id_for_short_name('Wise')
  #   @rit ||= Doogle::DisplayVendor.id_for_short_name('RIT')
  #   @etd ||= Doogle::DisplayVendor.id_for_short_name('ETD')
  #   @prime ||= Doogle::DisplayVendor.id_for_short_name('Prime')
  #   source_model_number = display.source_model_number
  #   if source_model_number.starts_with?('JY')
  #     if display.model_number[0..0] == 'H'
  #       @jiya
  #     elsif display.model_number[0..0] == 'M'
  #       @jiyalf
  #     else
  #       nil
  #     end
  #   elsif source_model_number.starts_with?('MI')
  #     @mit
  #   elsif source_model_number.starts_with?('NT')
  #     @nely
  #   elsif source_model_number.starts_with?('UG-') or source_model_number.starts_with?('UC-')
  #     @wise
  #   elsif source_model_number.starts_with?('G')
  #     @innolux
  #   elsif source_model_number.starts_with?('PD')
  #     @prime
  #   elsif source_model_number =~ /^P\d+/
  #     @rit
  #   elsif source_model_number.starts_with?('T')
  #     @etd
  #   else
  #     nil
  #   end
  # end
  #
  # def self.import_log(txt)
  #   log txt
  #   File.open(File.join(Rails.root, 'log/display_price_import.txt'), 'a') do |output|
  #     output.puts txt
  #   end
  # end
  #
  # UNKNOWN='Unknown'
  #
  # def self.import_from_display
  #   Doogle::Display.where('length(displays.source_model_number) > 0').by_model_number.each do |display|
  #     source_model_number = display.source_model_number.strip
  #     price = display.prices.detect { |p| p.vendor_part_number.strip == source_model_number }
  #     price ||= display.prices.build(:vendor_part_number => source_model_number, :start_date => '2010-01-01')
  #     if m2m_vendor_id = self.choose_vendor(display)
  #       price.m2m_vendor_id = m2m_vendor_id
  #       price.vendor_name = price.m2m_vendor.try(:name)
  #     end
  #     if price.vendor_name.blank?
  #       price.vendor_name = UNKNOWN
  #     end
  #     action = price.new_record? ? 'Created' : 'Updated'
  #     price.save!
  #     import_log "#{display.model_number}: #{action} price for #{source_model_number} with vendor #{price.vendor_name}"
  #   end
  #   true
  # end

end
