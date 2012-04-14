class Doogle::DisplayResource < ActiveResource::Base
  self.site = 'http://lxdinc.dev/doogle'
  self.format = :json
  
  def save
    prefix_options[:api_key] = AppConfig.doogle_api_key
    super
  end
end