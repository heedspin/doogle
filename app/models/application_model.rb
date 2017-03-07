# Copied from old LXD codebase
if !defined?(ApplicationModel)
  class ApplicationModel < ActiveRecord::Base
    self.abstract_class = true
    extend ActiveHash::Associations::ActiveRecordExtensions

    def self.attr_name(key)
      human_attribute_name(key)
    end

    def attr_name(key)
      self.class.attr_name(key)
    end

    def self.create_or_update(options = {}, import_stats=nil)
      if id = options.delete(:id)
        record = find_by_id(id) || new
        record.id = id
      elsif name = options[:name]
        record = find_by_name(name) || new
      elsif model_number = options[:model_number]
        record = find_by_model_number(model_number) || new
      else
        raise "No way to create or update Display with #{options.inspect}"
      end
      if import_stats
        if record.new_record?
          import_stats.created += 1
        else
          import_stats.updated += 1
        end
      end

      options.each_pair do |attr, value|
        record.send(attr.to_s + '=', value)
      end
      record.save!

      record
    end

    def cleaner_clean_url(attribute)
      if attribute_present?(attribute)
        self.send "#{attribute}=", cleaner_ensure_url(self.send(attribute))
      end
    end

    def cleaner_ensure_url(text)
      if text =~ /https?:\/\/.+/
        text
      else
        "http://#{text}"
      end
    end

    # Force http:// on a field BEFORE validation.
    # E.g.,
    # class MyModel < ActiveRecord::Base
    #   clean_urls :registration_url
    # end
    def self.clean_urls(*fields)
      before_validation do |obj|
        fields.each do |field|
          obj.cleaner_clean_url(field)
        end
      end
    end

    if Rails.env.test?
      def self.has_attached_file name, options = {}
        # puts "hasing attached file!"
        # super
      end
    end
  end
end
