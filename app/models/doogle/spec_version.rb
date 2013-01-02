# == Schema Information
#
# Table name: doogle_spec_versions
#
#  id                                :integer(4)      not null, primary key
#  status_id                         :integer(4)
#  display_id                        :integer(4)
#  version                           :integer(4)
#  comments                          :text
#  source_specification_file_name    :string(255)
#  source_specification_content_type :string(255)
#  source_specification_file_size    :integer(4)
#  source_specification_updated_at   :datetime
#  specification_file_name           :string(255)
#  specification_content_type        :string(255)
#  specification_file_size           :integer(4)
#  specification_updated_at          :datetime
#  specification_public              :boolean(1)
#  datasheet_updated_at              :datetime
#  datasheet_file_name               :string(255)
#  datasheet_content_type            :string(255)
#  datasheet_file_size               :integer(4)
#  datasheet_public                  :boolean(1)
#  drawing_updated_at                :datetime
#  drawing_file_name                 :string(255)
#  drawing_content_type              :string(255)
#  drawing_file_size                 :integer(4)
#  drawing_public                    :boolean(1)
#  updated_by_id                     :integer(4)
#  created_at                        :datetime
#  updated_at                        :datetime
#

require 'active_hash'

class Doogle::SpecVersion < ApplicationModel
  set_table_name 'doogle_spec_versions'
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status, :class_name => 'Doogle::SpecVersionStatus'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => :updated_by_id
  belongs_to :display, :class_name => 'Doogle::Display'
  validates_presence_of :display_id
  validates_uniqueness_of :version, :scope => 'display_id'

  scope :version, lambda { |version|
    {
      :conditions => { :version => version }
    }
  }
  scope :latest, :conditions => { :status_id => Doogle::SpecVersionStatus.latest.id }
  scope :by_version_desc, :order => 'doogle_spec_versions.version desc'

  [ [:datasheet, ':display_type/:model_number/v:version/LXD-:model_number-datasheet.:extension'],
    [:specification, ':display_type/:model_number/v:version/LXD-:model_number-spec.:extension'],
    [:source_specification, ':display_type/:model_number/v:version/non-public-:model_number-spec.:extension'],
    [:drawing, ':display_type/:model_number/v:version/LXD-:model_number-drawing-:style.:extension', {:thumbnail => '100>', :medium => '400>', :large => '600>'}]
  ].each do |key, path, image_styles|
    options = { :storage => :s3,
                :s3_credentials => { :access_key_id => AppConfig.doogle_access_key_id,
                                     :secret_access_key => AppConfig.doogle_secret_access_key },
                :url => ':s3_is_my_bitch_url',
                :bucket => AppConfig.doogle_bucket,
                :s3_permissions => 'authenticated-read',
                :path => path,
                :asset_key => key }
    options[:styles] = image_styles if image_styles
    has_attached_file key, options
  end

  def asset_public?(key)
    key = "#{key}_public"
    self.respond_to?(key) && self.send(key)
  end

  before_create :unset_latest
  def unset_latest
    if self.status.try(:latest?)
      connection.execute "update #{self.class.table_name} set status_id = #{Doogle::SpecVersionStatus.previous.id} where status_id = #{Doogle::SpecVersionStatus.latest.id} and display_id = #{self.display_id}"
    end
  end

  after_initialize :set_version
  def set_version
    if self.new_record?
      if self.has_attribute?(:version) and self.display_id # protect against scope.select(:column) error
        self.version = (Doogle::SpecVersion.maximum(:version, :conditions => { :display_id => self.display_id }) || 0) + 1
      end
    end
    if self.has_attribute?(:status_id)
      self.status ||= Doogle::SpecVersionStatus.latest
    end
  end

  def self.attach_latest(displays)
    self.where(['spec_versions.display_id in (?)', displays.map(&:id)]).latest.each do |spec|
      if display = displays.detect { |d| d.id == spec.display_id }
        display.latest_spec = spec
      end
    end
  end

  after_create :log_create
  def log_create
    # details = "Created spec version #{self.version}\n"
    # self.display.attachment_fields.each do |field|
    #   if self.send("#{field.key}?")
    #     details << "Uploaded #{field.label}: " + self.send("#{field.key}_file_name") + "\n"
    #   end
    # end
    Doogle::DisplayLog.create(:display => self.display,
                              :user_id => self.updated_by.try(:id),
                              :summary => 'Create Spec Version',
                              :details => Doogle::Display.inspect_changes(self.changes))
  end

  before_update :log_update
  def log_update
    Doogle::DisplayLog.create(:display => self.display,
                              :user_id => self.updated_by.try(:id),
                              :summary => 'Updated Spec Version',
                              :details => Doogle::Display.inspect_changes(self.changes))
  end

  def self.import_log(txt)
    File.open(File.join(Rails.root, 'log/spec_version_import.txt'), 'a') do |output|
      output.puts txt
    end
  end

  def self.import
    import_log "Starting import at " + Time.now.to_s
    Doogle::Display.by_model_number.all.each do |display|
      if display.spec_versions.count == 0
        begin
          dosave = false
          sr = display.spec_versions.build
          sr.comments = 'Initial import'
          display.attachment_fields.each do |field|
            if display.send("#{field.key}?")
              sr.send("#{field.key}=", display.send(field.key))
              dosave = true
            end
            if display.respond_to?("#{field.key}_public")
              sr.send("#{field.key}_public=", display.send("#{field.key}_public"))
            end
          end
          if dosave
            import_log "Creating spec revision for #{display.model_number}"
            sr.save!
          end
        rescue AWS::S3::Errors::NoSuchKey
          import_log "Datasheet for #{display.model_number} has moved! Did the type change?"
        end
      end
    end
  end
end
