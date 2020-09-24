Rails.application.routes.draw do
  devise_for :users,
             controllers: { registrations: 'users/registrations' },
             path_names: { edit: ':id/edit' }

  root 'posts#top'
  get 'about' => 'posts#about'
  get 'tags/:tag', to: 'posts#index', as: :tag
  get 'search' => 'users#search'
  get 'sort' => 'posts#sort'
  get 'inquiry' => 'inquiry#index'
  post 'inquiry/confirm' => 'inquiry#confirm'
  post 'inquiry/thanks' => 'inquiry#thanks'

  resources :posts do
    get 'category/:id' => 'posts#category', as: 'category', on: :collection
    resources :post_comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end

  resources :users, except: [:new, :index, :create, :edit, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
