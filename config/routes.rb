Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  resources :tasks do
    patch 'statuses', to: 'tasks/statuses#update'
    patch 'priorities', to: 'tasks/priorities#update'
  end
end
