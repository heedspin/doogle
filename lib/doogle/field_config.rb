class Doogle::FieldConfig
  attr_reader :key, :config, :field_type
  
  def initialize(config)
    @key = (config['key'] || (raise "missing field config key in #{config.inspect}")).to_sym
    @config = config
    @field_type = field_type
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

  def self.not_ignored
    self.all.select { |f| !f.ignored? }
  end
  
  def self.main
    self.all.select { |f| !f.ignored? and !f.composite_child? and !f.system? }
  end
  
  def aliases
    @alias ||= (self.config['aliases'] || '').split(',').map(&:strip)
  end
  
  def ignored?
    config['ignored']
  end
  
  def system?
    config['system']
  end
  
  def composite_child?
    @composite_child ||= Doogle::FieldConfig.composites.detect { |f| f.composite_children.include?(self) }.present?
  end
  
  def composite?
    self.dimension? || self.range?
  end
  
  def composite_children
    @composite_chilren ||= (config['dimension'] || config['range']).split(',').map { |child_key| Doogle::FieldConfig.for_key(child_key) }
  end
  
  def self.composites
    @composites ||= self.all.select { |f| f.composite? }
  end
  
  def should_import?
    !ignored?# && !system?
  end
  
  def display_name
    Doogle::Display.human_attribute_name(self.key)
  end
  
  def select?
    config.member? 'collection'
  end
  
  def collection_class
    if @collection_class.nil?
      collection_key = config['collection']
      if collection_key.is_a?(TrueClass)
        collection_key = self.key.to_s.classify
      end
      @collection_class = "Doogle::#{collection_key}".constantize
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

  def range?
    config.member? 'range'
  end
  
  def ranges
    @ranges ||= config['range'].split(',').map { |key| Doogle::FieldConfig.for_key(key) }
  end  
  
  def label
    config['label'] || Doogle::Display.human_attribute_name(self.key)
  end

end
