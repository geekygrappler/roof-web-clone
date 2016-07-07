Rails.application.routes.draw do
  mount RoofApi::Engine => "/api", as: :api
  get 'app' => 'pages#app'
  get 'app/*path' => 'pages#app'
  get 'pages/*path' => 'pages#show'
  root to: 'pages#show', pathname: 'landing'
  get "*path" => "pages#show", pathname: '404'
  patch '/api/tender_templates/:id/toggle_searchable', to: 'tender_templates#toggle_searchable'
end
