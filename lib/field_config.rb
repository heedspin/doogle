class FieldConfig
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
        @all.push FieldConfig.new(config_hash)
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
      args.flatten.map { |a| @map[a.to_s] }
    else
      nil
    end
  end  

  def self.for_key(key)
    (self.for_keys(key) || []).first
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
  
  def aliases
    @alias ||= (self.config['aliases'] || '').split(',').map(&:strip)
  end
  
  def ignored?
    config['ignored']
  end
  
  def system?
    config['system']
  end
  
  def should_import?
    !ignored?# && !system?
  end
  
  def display_name
    Doogle::Display.human_attribute_name(self.key)
  end

end
