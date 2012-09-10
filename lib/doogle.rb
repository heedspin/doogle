module Doogle
  class Engine < ::Rails::Engine
    # config.autoload_paths << File.expand_path("../app", __FILE__)
  end
end

require 'doogle_config'
require 'doogle/display_config'
require 'doogle/field_config'
