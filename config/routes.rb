Rails.application.routes.draw do
  resources :users, only: :show do
    resource :password, only: [:edit, :update]
  end

  resources :passwords, only: :create

  post 'authenticate', to: 'authentication#create'
  post '/signup', to: 'users#create'
end
