Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'groups#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :groups, shallow: true do
    resources :tasks do
      put :sort
      patch 'statuses', to: 'tasks/statuses#update'
      patch 'priorities', to: 'tasks/priorities#update'
      patch 'read_datestamps', to: 'tasks/read_datestamps#update'
    end
  end

  get 'labels', to: 'labels#index'

  get 'users/mypage', to: 'users#show'
  get 'users/edit', to: 'users#edit'
  patch 'users/edit', to: 'users#update'
    

  namespace :admin do
    resources :users
  end
end
