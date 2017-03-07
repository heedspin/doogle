Rails.application.routes.draw do
  namespace :doogle do
    resources :displays do
      collection do
        get 'next_model_number'
        get 'web_preview'
      end
      resources :display_logs, :controller => 'displays/logs'
      resources :spec_versions, :controller => 'displays/spec_versions'
      resources :prices, :controller => 'displays/prices' do
        collection do
          get :clone
        end
      end
    end
    resources :display_component_vendors, :only => :index
    resources :touch_panel_component_vendors, :only => :index
    resources :display_resources, :only => [ :show, :create, :update, :destroy ]
    resources :logs, :only => [ :show, :index ]
    resources :spec_versions, :only => :index
    resources :vendor_names, :only => :index
  end
  resources :display_assets, :only => [ :show ]
  match '/display_assets/', :controller => 'display_assets', :action => 'options', :via => [:options]
end
