Rails.application.routes.draw do
  get 'users/index'
  get 'users/edit'
  get 'users/show'
  get 'relationships/follower'
  get 'relationships/followed'
  get 'posts/top'
  get 'posts/about'
  get 'posts/index'
  get 'posts/new'
  get 'posts/edit'
  get 'posts/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
