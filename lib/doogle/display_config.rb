class Doogle::DisplayConfig
  def self.map
    if @map.nil?
      @map = {}
      self.all.each do |config|
        @map[config.key.to_s] = config
        config.aliases.each do |key|
          @map[key.to_s] = config
        end
      end
    end
    @map
  end
  def self.for_keys(*args)
    if args and (args.size > 0)
      args.flatten.map { |a| self.map[a.to_s] }
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

  def self.edit
    self.all.select { |dc| dc.key != :any }
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
      required.split(',').map(&:strip).uniq
    else
      []
    end
  end

  def optional_field_keys
    @optional_field_keys ||= self.field_keys - self.required_field_keys
  end

  def field_keys
    @field_keys ||= if fk = @config['fields']
      fk.split(',').map(&:strip).uniq
    else
      []
    end
  end

  def fields
    @fields ||= self.field_keys.map { |k| Doogle::FieldConfig.for_key(k) }
  end

  def sorted_fields
    @sorted_fields ||= self.fields.sort_by(&:name)
  end

  def sorted_search_fields
    @sorted_search_fields ||= self.sorted_fields.select(&:searchable?)
  end

  def default_search_fields
    @default_search_fields ||= if keys = @config['default_search_fields']
      keys.split(',').map { |k| Doogle::FieldConfig.for_key(k.strip) }
    else
      self.fields
    end
  end

  def web_list_fields
    if @web_list_fields.nil?
      fields = if (keys = @config['web_list'])
        keys.split(',').map(&:strip).uniq.map { |k| Doogle::FieldConfig.for_key(k.strip) }
      else
        []
      end
      @web_list_fields = fields.select { |f| f.web? }
    end
    @web_list_fields
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

  def max_model_number
    result = if self.key == :tft_displays
      Doogle::Display.connection.select_one <<-SQL
      select max(substring(model_number, 2)) from displays
      where (model_number like "_7%")
      SQL
    else
      Doogle::Display.connection.select_one <<-SQL
      select max(substring(model_number, 2)) from displays
      where ((model_number like "H%")
             or (model_number like "M%")
             or (model_number like "A%")
             or (model_number like "L%"))
      and (model_number not like "_7%")
      SQL
    end
    if result.values.size > 0
      self.model_number_prefix + result.values.first
    else
      self.model_number_prefix + '000A'
    end
  end

  def next_model_number
    model_number = self.max_model_number
    if model_number =~ /(\w)(\d+)(\w)?/
      prefix = $1
      number = $2
      revision = $3
      prefix + number.succ + 'A'
    else
      model_number.succ
    end
  end

  def method_missing(mid, *args)
    if config.member?(mid.to_s)
      config[mid.to_s]
    else
      super
    end
  end

end
