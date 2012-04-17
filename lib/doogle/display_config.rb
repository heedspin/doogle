class Doogle::DisplayConfig
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
      args.flatten.map { |a| @map[a.to_s] }
    else
      nil
    end
  end
  
  def self.find_by_key(key)
    (self.for_keys(key) || []).first
  end
  
  def self.find_by_tab(txt)
    self.all.detect { |dc| dc.tab_name?(txt) }
  end
  
  def self.all
    if @all.nil?
      @all = []
      DoogleConfig.display_types.each do |config_hash|
        @all.push Doogle::DisplayConfig.new(config_hash)
      end
    end
    @all
  end
  
  def self.options
    self.all.sort_by(&:name).map { |dc| [ dc.name, dc.key ] }
  end
  
  attr_reader :key, :config, :name
  def initialize(config)
    @key = (config['key'] || (raise "missing display config key in #{config.inspect}")).to_sym
    @config = config
    @name = config['name'] || self.key.to_s.humanize.titleize.singularize
  end
  
  def id
    self.key.to_s
  end
  
  def aliases
    @alias ||= (self.config['alias'] || '').split(',').map(&:strip)
  end
  
  def required_field_keys
    @required_field_keys ||= if required = @config['required']
      required.split(',').map(&:strip)
    else
      []
    end
  end

  def optional_field_keys
    @optional_field_keys ||= self.field_keys - self.required_field_keys
  end

  def field_keys
    @field_keys ||= if field_keys = @config['fields']
      field_keys.split(',').map(&:strip)
    else
      []
    end
  end  
    
  def fields
    @fields ||= self.field_keys.map { |k| Doogle::FieldConfig.for_key(k) }
  end
  
  def web_fields
    if @web_fields.nil?
      fields = if keys = @config['web_fields']
        keys.split(',').map { |k| Doogle::FieldConfig.for_key(k.strip) }
      else
        self.fields
      end
      @web_fields = fields.select { |f| f.web? }
    end
    @web_fields
  end

  def web_list_fields
    if @web_list_fields.nil?
      fields = if keys = @config['web_list']
        keys.split(',').map { |k| Doogle::FieldConfig.for_key(k.strip) }
      else
        self.web_fields
      end
      @web_list_fields = fields.select { |f| f.web? }
    end
    @web_list_fields
  end
  
  def export_fields
    # Remove type since it's implicit in the spreadsheet tab name.
    Doogle::FieldConfig.system_fields + fields# - [ 'type' ]
  end
  
  def active_field?(field)
    key = field.is_a?(Doogle::FieldConfig) ? field.key.to_s : field.to_s
    required_field_keys.include?(key) or optional_field_keys.include?(key)
  end
  
  def required_field?(field)
    required_field_keys.include?(field.key.to_s)
  end
  
  def optional_field?(key)
    key = key.to_s
    optional_field_keys.include?(key)
  end
  
  def tab_names
    @tab_names ||= (self.config['tab_names'] || '').split(',').map(&:strip)
  end
  
  def short_name
    tab_names.first
  end
  
  def tab_name?(txt)
    self.tab_names.map(&:downcase).include?(txt.downcase)
  end
  
  def self.key_to_field_keys
    result = {}
    self.all.each do |display_config|
      result[display_config.key] = display_config.fields.map(&:key)
    end
    result
  end
  
end
