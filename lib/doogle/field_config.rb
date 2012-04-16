class Doogle::FieldConfig
  attr_reader :key, :config, :field_type, :description

  def initialize(config)
    @key = (config['key'] || (raise "missing field config key in #{config.inspect}")).to_sym
    @config = config
    @field_type = field_type
    @description = config['description']
  end

  def column
    @column ||= config['column'] || (self.belongs_to? ? "#{self.key}_id" : self.key)
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
    self.all.select { |f| f.top_level? }
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

  def self.for_name(name)
    if @name_map.nil?
      @name_map = {}
      self.all.each do |config|
        @name_map[Doogle::Display.human_attribute_name(config.key).downcase] = config
        config.aliases.each do |alias_name|
          puts "Added alias #{alias_name} for #{config.key}"
          @name_map[alias_name.downcase] = config
        end
      end
    end
    @name_map[name.try(:downcase).try(:strip)]
  end

  def self.system_fields
    self.all.select { |f| f.system? }
  end

  def self.main
    self.all.select { |f| !f.composite_child? and !f.system? }
  end

  def aliases
    @alias ||= (self.config['aliases'] || '').split(',').map(&:strip)
  end

  def system?
    if @system.nil?
      @system = config['system']
    end
    @system
  end

  def web?
    if @web.nil?
      @web = config['web']
      @web = true if @web.nil?
    end
    @web
  end

  def searchable
    if @searchable.nil?
      @searchable = config['search']
    end
    @searchable
  end

  def searchable?
    if self.searchable.nil?
      !self.attachment?
    else
      self.searchable.is_a?(String) ? true : self.searchable
    end
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

  def composite_children
    @composite_chilren ||= config['dimension'].split(',').map { |child_key| Doogle::FieldConfig.for_key(child_key) }
  end

  def self.composites
    @composites ||= self.all.select { |f| f.composite? }
  end

  def self.non_composites
    @non_composites ||= self.all.select { |f| !f.composite? }
  end

  def display_name
    Doogle::Display.human_attribute_name(self.key)
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

  def belongs_to_class
    if @belongs_to_class.nil?
      collection_class_name = config['belongs_to']
      collection_class_name = collection_class_name.is_a?(String) ? collection_class_name : self.key.to_s.classify
      @belongs_to_class = "Doogle::#{collection_class_name}".constantize
    end
    @belongs_to_class
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

  def label
    config['label'] || Doogle::Display.human_attribute_name(self.key)
  end

  def short_label
    config['short_label'] || self.label
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
