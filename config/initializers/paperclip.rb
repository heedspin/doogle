Paperclip.interpolates :model_number do |attachment, style|
  attachment.instance.is_a?(Doogle::Display) ? attachment.instance.model_number : attachment.instance.display.model_number
end

Paperclip.interpolates :version do |attachment, style|
  attachment.instance.version
end

Paperclip.interpolates :display_type do |attachment, style|
  attachment.instance.is_a?(Doogle::Display) ? attachment.instance.display_type.key : attachment.instance.display.display_type.key
end

Paperclip.interpolates :s3_is_my_bitch_url do |attachment, style|
  display = attachment.instance.is_a?(Doogle::Display) ? attachment.instance : attachment.instance.display
  model_number = URI.escape(display.model_number, "/")
  options = [ ]
  if attachment.instance.is_a?(Doogle::SpecVersion)
    options.push "version=#{attachment.instance.version}"
  end
  options.push "asset=#{attachment.options[:asset_key]}"
  "/display_assets/#{model_number}?" + options.join('&')
end
