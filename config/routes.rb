Rails.application.routes.draw do
  resources :posts
  get '/map' =>'posts#map'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
