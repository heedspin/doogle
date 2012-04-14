require 'rails/generators'
require 'rails/generators/migration'

class DoogleGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path(File.join(File.dirname(__FILE__), '../..'))

  # Every method that is declared below will be automatically executed when the generator is run  
  def copy_migration_files   
    Dir.glob(File.join(DoogleGenerator.source_root, 'db/migrate/*')).each do |source|
      destination = File.join(Rails.root, 'db/migrate', File.basename(source))
      puts "    \e[1m\e[34mcopying\e[0m  #{source} to #{destination}"
      copy_file source, destination
    end
  end

  # def copy_initializer_file
  #   copy_file 'initializer.rb', 'config/initializers/cheese.rb'
  # end
end
