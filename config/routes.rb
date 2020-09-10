Rails.application.routes.draw do
  devise_for :users
  root 'posts#top'
  get 'about' => 'posts#about'
  get 'tags/:tag', to: 'posts#index', as: :tag
  get 'search' => 'users#search'
  get 'sort' => 'posts#sort'

  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end

  resources :users, except: [:new, :create, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
