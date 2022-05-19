Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#create'
  resources :users, only: :show
  post '/signup', to: 'users#create'
end
