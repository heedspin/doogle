module Doogle::HasDoogleAttachments
  def self.included(base)
    [ [:datasheet, ':display_type/:model_number/LXD-:model_number-datasheet.:extension'],
      [:specification, ':display_type/:model_number/LXD-:model_number-spec.:extension'],
      [:source_specification, ':display_type/:model_number/non-public-:model_number-spec.:extension'],
      [:drawing, ':display_type/:model_number/LXD-:model_number-drawing-:style.:extension', {:thumbnail => '100>', :medium => '400>', :large => '600>'}]
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
      base.has_attached_file key, options
    end
  end

end

Paperclip.interpolates :model_number do |attachment, style|
  attachment.instance.model_number
end

Paperclip.interpolates :display_type do |attachment, style|
  attachment.instance.display_type.key
end

Paperclip.interpolates :s3_is_my_bitch_url do |attachment, style|
  model_number = URI.escape(attachment.instance.model_number, "/")
  "/display_assets/#{model_number}?asset=#{attachment.options[:asset_key]}"
end
