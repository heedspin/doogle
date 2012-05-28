Rails.application.routes.draw do
  namespace :doogle do 
    resources :displays do
      collection do
        get 'next_model_number'
      end
      resources :display_logs
    end
    resources :display_resources, :only => [ :show, :create, :update, :destroy ]
    resources :logs, :only => [ :show, :index ]
  end
  resources :display_assets, :only => [ :show ]
end
