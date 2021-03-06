Rails.application.routes.draw do
  namespace :api do
    get '/products' => 'products#index'
    post '/products' => 'products#create'
    get '/products/:id' => 'products#show'
    patch '/products/:id' => 'products#update'
    delete 'products/:id' => 'products#destroy'

    post '/users' => 'users#create'

    post '/sessions' => 'sessions#create'


    get '/orders' => 'orders#index'
    post '/orders' => 'orders#create'

    get '/carted_products' => 'carted_products#index'
    get '/carted_products/:id' => 'carted_products#show'
    post '/carted_products' => 'carted_products#create'

  end
end
