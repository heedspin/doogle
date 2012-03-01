require 'ostruct'
require 'yaml'

unless defined?(::DoogleConfig)
  class DoogleConfigStruct < OpenStruct
    def initialize(args)
      super
    end
    def method_missing(mid, *args)
      if mid.to_s =~ /(.+)\?$/
        val = send($1)
        if val.nil?
          return false
        elsif val.is_a?(FalseClass) or val.is_a?(TrueClass)
          return val
        else
          return !['0', 'false', 'nil'].include?(val.downcase)
        end
      else
        super
      end
    end
  end
  config_hash = {}
  config_file = File.join(Doogle::Engine.root, 'config', 'doogle_config.yml')
  if File.exist?(config_file)
    if (contents = YAML::load(ERB.new(IO.read(config_file)).result)) and (not contents.nil?)  
      if contents.has_key? Rails.env.downcase
        contents = contents[Rails.env.downcase]
      end
      config_hash.merge! contents
    end
  end
  ::DoogleConfig = DoogleConfigStruct.new(config_hash)
end

require 'doogle/display_config'
require 'doogle/field_config'
