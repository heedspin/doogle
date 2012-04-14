Rails.application.routes.draw do
  namespace :doogle do 
    resources :displays
    resources :display_resources, :only => [ :show, :create, :update, :destroy ]
  end  
end
