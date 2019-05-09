Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :tasks do
    patch 'statuses', to: 'tasks/statuses#update'
    patch 'priorities', to: 'tasks/priorities#update'
    patch 'read_datestamps', to: 'tasks/read_datestamps#update'
  end

  namespace :admin do
    resources :users
  end
end
