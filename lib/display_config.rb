class DisplayConfig
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
      DoogleConfig.display_types.each_pair do |k, c|
        @all.push DisplayConfig.new(k, c)
      end
    end
    @all
  end
  
  def self.options
    self.all.sort_by(&:name).map { |dc| [ dc.name, dc.key ] }
  end
  
  attr_reader :key
  attr_reader :config
  def initialize(key, config)
    @key = key.to_sym
    @config = config
  end
  
  def aliases
    @alias ||= (self.config['alias'] || '').split(',').map(&:strip)
  end
  
  def name
    @name ||= config['name']
  end
  
  def required_field_keys
    @required_field_keys ||= if required = @config['required']
      required.split(',').map(&:strip)
    else
      []
    end
  end
  
  def optional_field_keys
    @optional_field_keys ||= if optional = @config['optional']
      optional.split(',').map(&:strip)
    else
      []
    end
  end
  
  def fields
    @fields ||= (required_field_keys + optional_field_keys).map { |k| FieldConfig.for_key(k) }
  end

  def export_fields
    # Remove type since it's implicit in the spreadsheet tab name.
    FieldConfig.system_fields + fields# - [ 'type' ]
  end
  
  def active_field?(field)
    key = field.is_a?(FieldConfig) ? field.key.to_s : field.to_s
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
