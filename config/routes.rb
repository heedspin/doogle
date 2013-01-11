Rails.application.routes.draw do
  namespace :doogle do 
    resources :displays do
      collection do
        get 'next_model_number'
        get 'web_preview'
      end
      resources :display_logs, :controller => 'displays/logs'
      resources :spec_versions, :controller => 'displays/spec_versions'
    end
    resources :display_resources, :only => [ :show, :create, :update, :destroy ]
    resources :logs, :only => [ :show, :index ]
    resources :spec_versions, :only => :index
  end
  resources :display_assets, :only => [ :show ]
end
