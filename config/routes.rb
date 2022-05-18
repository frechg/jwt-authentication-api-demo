Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#create'
  resources :users, only: :show
end
