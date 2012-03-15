class Doogle::FieldConfig
  attr_reader :key, :config, :field_type, :description
  
  def initialize(config)
    @key = (config['key'] || (raise "missing field config key in #{config.inspect}")).to_sym
    @config = config
    @field_type = field_type
    @description = config['description']
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
  
  def has_many?
    if @has_many.nil?
      @has_many = config['has_many']
    end
    @has_many
  end
  
  
    
  def system?
    if @system.nil?
      @system = config['system']
    end
    @system
  end
  
  def searchable
    if @searchable.nil?
      @searchable = config['searchable']
    end
    @searchable
  end

  def searchable?
    self.searchable.nil? ? true : (self.searchable.is_a?(String) ? true : self.searchable)
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
    c = config['search_range']
    c.is_a?(String) ? c : "#{self.key}_range"
  end
  
  def search_range_class
    "Doogle::#{self.search_range_attribute.to_s.classify}".constantize
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
  
  def display_name
    Doogle::Display.human_attribute_name(self.key)
  end
  
  def select?
    config['select']
  end
  
  def collection_class
    if @collection_class.nil?
      collection_class_name = config['collection']
      collection_class_name = collection_class_name.nil? ? self.key.to_s.classify : collection_class_name
      @collection_class = "Doogle::#{collection_class_name}".constantize
    end
    @collection_class
  end
  
  def collection
    @collection ||= self.collection_class.all
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
