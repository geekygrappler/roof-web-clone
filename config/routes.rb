Rails.application.routes.draw do

  get 'search/line_items', to: 'search#line_items'
  get 'search/building_materials', to: 'search#building_materials'

  get 'spec/new', to: 'spec#new', as: :new_spec
  get 'spec/create', to: 'spec#create', as: :create_spec
  get 'spec/invite', to: 'spec#invite', as: :invite_spec
  get 'spec/thanks', to: 'spec#thanks', as: :thanks_spec

  #devise_for :accounts, path: '/users'
  #
  #devise_scope :account do
  #  get '/sign_in', to: 'sessions#new', as: :sign_in
  #  post '/sign_in', to: 'sessions#create', as: :sign_in_post
  #end

  resources :line_items, except: [:new, :edit]
  resources :building_materials, except: [:new, :edit]
  resources :documents, except: [:edit]
  resources :sections, except: [:new, :edit]
  mount RoofApi::Engine => "/api", as: :api
  get 'app' => 'pages#app'
  get 'app/*path' => 'pages#app'
  get 'pages/*path' => 'pages#show'
  root to: 'pages#show', pathname: 'landing'
  get "*path" => "pages#show", pathname: '404'
  patch '/api/tender_templates/:id/toggle_searchable', to: 'tender_templates#toggle_searchable'
  post '/api/pdf/upload_pdf', to: 'pdf#upload_pdf'

  resources :backup_types, except: [:new, :edit]
  resources :state_types, except: [:new, :edit]
  resources :locations, except: [:new, :edit]
  resources :document_states, except: [:new, :edit]
  resources :documents, except: [:new, :edit]
end
