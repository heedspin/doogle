Doogle::Engine.routes.draw do
  match 'doogle' => 'doogle/displays#index'
  resources :displays, :only => [ :index, :show ], :controller => "doogle/displays", :path_prefix => 'doogle', :name_prefix => "doogle_"
end
