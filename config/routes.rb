Rails.application.routes.draw do
  mount RoofApi::Engine => "/api", as: :api
  get 'app' => 'pages#app'
  get 'app/*path' => 'pages#app'
  get 'pages/*path' => 'pages#show'
  root to: 'pages#show', pathname: 'landing'
end
