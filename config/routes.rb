Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'wallet#index'
  get '/index', to: 'wallet#index'
  get '/receive', to: 'wallet#receive'
end
