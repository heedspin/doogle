class Doogle::SpecVersionResource < ActiveResource::Base
  self.site = AppConfig.doogle_lxdinc_site
  self.format = :json

  def status
    self.status_id && Doogle::SpecVersionStatus.find(self.status_id)
  end  
  
  def self.find(id)
    super(id, :params => {:api_key => AppConfig.doogle_api_key})
  end
  
  def destroy
    prefix_options[:api_key] = AppConfig.doogle_api_key
    super
  end
  
  def save
    prefix_options[:api_key] = AppConfig.doogle_api_key
    super
  end
end