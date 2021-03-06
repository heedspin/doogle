require 'doogle/formatting'

class Doogle::FieldConfig
  include Doogle::Formatting
  include ActionView::Helpers::UrlHelper
  attr_reader :key, :config, :field_type, :description

  def initialize(config)
    @key = (config['key'] || (raise "missing field config key in #{config.inspect}")).to_sym
    @config = config
    @field_type = field_type
    @description = config['description']
  end

  def search_input
    @search_input ||= if si = config['search_input']
      si
    elsif self.search_options?
      "#{self.search_option_attribute}_id"
    elsif self.search_belongs_to?
      "#{self.key}_id"
    else
      self.key
    end
  end

  def edit_input
    @edit_input ||= if ei = config['edit_input']
      ei
    elsif self.belongs_to?
      "#{self.key}_id"
    elsif v = config['db_value']
      v
    else
      self.key
    end
  end

  def search_value_key
    @search_value_key ||= if self.search_options?
      self.search_option_attribute
    elsif sv = config['search_value']
      sv
    elsif self.search_belongs_to?
      self.key
    elsif self.search_range?
      self.search_range_attribute
    elsif v = config['db_value']
      v
    else
      self.key
    end
  end

  def db_value_key
    @db_value_key ||= if v = config['db_value']
      v
    elsif self.belongs_to?
      "#{self.key}_id"
    else
      self.key
    end
  end

  def render_value_key
    @render_value_key ||= (config['render_value'] || config['db_value'] || self.key)
  end

  def search_scope_key
    @search_scope_key ||= if (c = config['search_scope'])
      c
    elsif self.search_range?
      self.search_range_attribute
    elsif self.search_options?
      self.search_option_attribute
    else
      self.key
    end
  end

  def display_type?
    self.key == :display_type
  end

  def self.all
    if @all.nil?
      @all = []
      DoogleConfig.display_fields.each do |config_hash|
        @all.push Doogle::FieldConfig.new(config_hash)
      end
    end
    @all
  end

  def self.top_level
    @top_level ||= self.all.select { |f| f.top_level? }
  end

  def self.sorted_top_level
    @sorted_top_level ||= self.top_level.sort_by(&:name)
  end

  def self.for_keys(*args)
    if @map.nil?
      @map = {}
      self.all.each do |config|
        @map[config.key.to_s] = config
        config.aliases.each do |key|
          @map[key.to_s] = config
        end
      end
    end
    if args and (args.size > 0)
      args.flatten.map { |a| @map[a.to_s.strip] }
    else
      nil
    end
  end

  def self.for_key(key)
    (self.for_keys(key) || []).first || (raise "No field config for #{key}")
  end

  # def self.for_name(name)
  #   if @name_map.nil?
  #     @name_map = {}
  #     self.all.each do |config|
  #       @name_map[Doogle::Display.human_attribute_name(config.key).downcase] = config
  #       config.aliases.each do |alias_name|
  #         puts "Added alias #{alias_name} for #{config.key}"
  #         @name_map[alias_name.downcase] = config
  #       end
  #     end
  #   end
  #   @name_map[name.try(:downcase).try(:strip)]
  # end

  def self.main
    self.all.select { |f| !f.composite_child? }
  end

  def self.editable
    self.main.select { |f| f.editable? }
  end

  def self.config_accessor(key, default)
    key = key.to_s
    self.class_eval <<-RUBY
    def #{key}
      if @#{key}.nil?
        @#{key} = !config.member?('#{key}') ? #{default} : config['#{key}']
      end
      @#{key}
    end
    RUBY
  end

  def aliases
    @alias ||= (self.config['aliases'] || '').split(',').map(&:strip)
  end

  def web?
    if @web.nil?
      v = config['web']
      @web = v.is_a?(TrueClass) || v.nil?
    end
    @web
  end

  def searchable?
    if @searchable.nil?
      v = config['search']
      @searchable = v.is_a?(TrueClass) || v.nil?
    end
    @searchable
  end

  def self.searchable
    self.all.select { |f| f.searchable? and !f.composite_child? }
  end

  def search_range?
    config.member? 'search_range'
  end

  def self.search_ranges
    self.all.select { |f| f.search_range? }
  end

  def search_range_attribute
    "#{self.key}_range"
  end

  def search_range_class
    if @search_range_class.nil?
      c = config['search_range']
      class_name = c.is_a?(String) ? c : self.search_range_attribute.to_s.classify
      @search_range_class = "Doogle::#{class_name}".constantize
    end
    @search_range_class
  end

  def search_range_collection
    @search_range_collection ||= self.search_range_class.all
  end

  def search_range_options
    self.search_range_collection.map { |o| [o.name, o.id]}
  end

  def search_options?
    config.member? 'search_options'
  end

  def search_option_attribute
    "#{self.key}_option"
  end

  def search_options_class
    if @search_options_class.nil?
      c = config['search_options']
      class_name = c.is_a?(String) ? c : self.search_option_attribute.classify
      @search_options_class = "Doogle::#{class_name}".constantize
    end
    @search_options_class
  end

  def search_options_class_member_label
    return nil unless search_options?
    if search_options_class.respond_to?(:member_label)
      search_options_class.member_label
    else
      :name
    end
  end
  
  def renderable?
    if @renderable.nil?
      v = config['renderable']
      @renderable = v.is_a?(TrueClass) || v.nil?
    end
    @renderable
  end

  config_accessor :search_include_blank, true
  config_accessor :edit_include_blank, true
  config_accessor :sprintf_config, false

  def composite_parent
    @composite_parent ||= Doogle::FieldConfig.composites.detect { |f| f.composite_children.include?(self) } || self
  end

  def composite_child?
    if @composite_child.nil?
      @composite_child = !self.top_level?
    end
    @composite_child
  end

  def top_level?
    self.composite_parent == self
  end

  def composite?
    self.dimension?
  end

  def web?
    if @web.nil?
      v = config['web']
      @web = v.is_a?(TrueClass) || v.nil?
    end
    @web
  end

  def editable?
    if @editable.nil?
      v = config['editable']
      @editable = v.is_a?(TrueClass) || v.nil?
    end
    @editable
  end

  def composite_children
    @composite_chilren ||= config['dimension'].split(',').map { |child_key| Doogle::FieldConfig.for_key(child_key) }
  end

  def self.composites
    @composites ||= self.all.select { |f| f.composite? }
  end

  def self.non_composites
    @non_composites ||= self.all.select { |f| !f.composite? }
  end

  def name
    # Doogle::Display.human_attribute_name(self.key)
    @name ||= (config['name'] || self.key.to_s.titleize)
  end

  def table_name
    @table_name ||= (config['table_name'] || self.name)
  end

  def label
    @label ||= (config['label'] || self.name)
  end

  def wrapper_id
    "display_#{self.key}_input"
  end

  def short_label
    config['short_label'] || self.label
  end

  def attachment?
    if @attachment.nil?
      @attachment = config['attachment'].present?
    end
    @attachment
  end

  def belongs_to?
    if @belongs_to.nil?
      @belongs_to = config['belongs_to'].present?
    end
    @belongs_to
  end

  def search_belongs_to?
    if @search_belongs_to.nil?
      @search_belongs_to = config['search_belongs_to'].present? || self.belongs_to?
    end
    @search_belongs_to
  end

  def search_belongs_to_class
    if @search_belongs_to_class.nil?
      collection_class_name = config['search_belongs_to'] || config['belongs_to']
      collection_class_name = collection_class_name.is_a?(String) ? collection_class_name : self.key.to_s.classify
      @search_belongs_to_class = "Doogle::#{collection_class_name}".constantize
    end
    @search_belongs_to_class
  end

  def belongs_to_class
    if @belongs_to_class.nil?
      collection_class_name = config['belongs_to']
      collection_class_name = collection_class_name.is_a?(String) ? collection_class_name : self.key.to_s.classify
      @belongs_to_class = "Doogle::#{collection_class_name}".constantize
    end
    @belongs_to_class
  end

  def belongs_to_class_member_label
    return nil unless belongs_to?
    if belongs_to_class.respond_to?(:member_label)
      belongs_to_class.member_label
    else
      :name
    end
  end

  def has_many?
    if @has_many.nil?
      @has_many = config['has_many']
    end
    @has_many
  end

  def has_many_class
    if @has_many_class.nil?
      collection_class_name = config['has_many_class']
      collection_class_name = collection_class_name.is_a?(String) ? collection_class_name : self.key.to_s.classify
      @has_many_class = "Doogle::#{collection_class_name}".constantize
    end
    @has_many_class
  end

  def dimension?
    config.member? 'dimension'
  end

  def dimensions
    @dimensions ||= config['dimension'].split(',').map { |key| Doogle::FieldConfig.for_key(key) }
  end

  def search_as
    config['search_as']
  end

  def units
    @units ||= config['units']
  end
  def units_short
    @units_short ||= config['units_short']
  end

  def render(display, args={})
    search = args[:search]
    format = args[:format] || :html
    value = if self.model_number?
      if format == :html
        link_to( doogle_search_excerpt(display.model_number, search.try(:model_number)),
                 Rails.application.routes.url_helpers.doogle_display_url(display, :host => AppConfig.hostname),
                 {:target => '_blank'} )
      else
        display.model_number
      end
    elsif self.comment?
      doogle_search_excerpt(display.comment, search.try(:comment))
    elsif self.integrated_controller?
      doogle_search_excerpt(display.integrated_controller, search.try(:integrated_controller))
    elsif self.display_type?
      display.display_type.try(:name)
    elsif self.character_rows? or self.character_columns?
      doogle_cm(display.send(self.render_value_key))
    elsif self.has_many?
      display.send(self.render_value_key).map { |v| v.try(:name) }.join(', ')
    elsif self.dimension?
      dimension_values = []
      self.dimensions.each do |child_field|
        child_value = child_field.render(display)
        break unless child_value.present?
        dimension_values.push child_value
      end
      dimension_joiner = self.key.to_s.include?('temperature') ? ' to ' : ' x '
      default_render_value dimension_values.join(dimension_joiner)
    elsif self.attachment?
      if (latest_spec = display.latest_spec) and latest_spec.send("#{self.render_value_key}?")
        filename = latest_spec.send("#{self.render_value_key}_file_name")
        if format == :html
          link_to filename, latest_spec.send(self.render_value_key).try(:url), {:target => '_blank'}
        elsif format == :xls
          url = 'https://' + AppConfig.hostname + latest_spec.send(self.render_value_key).try(:url)
          Spreadsheet::Link.new url, filename
        else
          filename
        end
      else
        ''
      end
    elsif self.previous_revision_id?
      if display.previous_revision
        if format == :html
          link_to( display.previous_revision.model_number,
                   Rails.application.routes.url_helpers.doogle_display_url(display.previous_revision, :host => AppConfig.hostname) )
        else
          display.previous_revision.model_number
        end
      end
    elsif self.erp_id?
      if display.item
        if format == :html
          link_to( 'M2M Item',
                   Rails.application.routes.url_helpers.item_url(display.item, :host => AppConfig.hostname) )
        else
          "M2M Item #{display.item.id}"
        end
      end
    elsif self.search_vendor?
      if format == :html
        display.vendors.map do |v|
          if v.m2m_vendor
            link_to( v.short_name,
                     Rails.application.routes.url_helpers.vendor_url(v.m2m_vendor, :host => AppConfig.hostname) )
          else
            v.short_name
          end
        end.join(', ')
      else
        display.vendors.map(&:short_name).join(', ')
      end
    elsif self.vendor_part_number?
      display.vendors.map do |v|
        doogle_search_excerpt(v.vendor_part_number, search.try(:vendor_part_number))
      end.join(', ')
    else
      self.default_render_field(display)
    end
    (value.is_a?(String) and (format == :html)) ? value.try(:html_safe) : value
  end

  def default_render_field(display)
    val = display.send(self.render_value_key)
    val = if val.is_a?(Numeric)
      val = sprintf("%.1f",val) if val.is_a?(Float)
      doogle_cm(val)
    else
      val.try(:to_s)
    end
    self.default_render_value(val)
  end

  def default_render_value(val)
    if val.present?
      if self.units_short
        val = "#{val} #{self.units_short}"
      elsif self.sprintf_config
        val = sprintf(self.sprintf_config, val)
      end
    end
    val
  end

  # Allows stuff like this:
  # Doogle::FieldConfig.for_key(:module_dimensions).module_dimensions?
  # => true
  def method_missing(mid, *args)
    if mid.to_s =~ /(.+)\?$/
      return $1 == self.key.to_s
    else
      super
    end
  end

end
