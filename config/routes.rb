Rails.application.routes.draw do

  get 'admin/specs', to: 'admin_spec#specs'
  get '/admin/document/:id', to: 'admin_spec#document', as: :admin_document
  delete '/admin/architect/:id', to: 'admin_spec#destroy_architect', as: :destroy_architect
  delete '/admin/invite/:id', to: 'admin_spec#destroy_invite', as: :destroy_invite
  post '/admin/invite/:id', to: 'admin_spec#send_pro_email', as: :send_pro_email

  get 'search/line_items', to: 'search#line_items'
  get 'search/building_materials', to: 'search#building_materials'
  get 'search/items', to: 'search#items'
  get 'search/specs', to: 'search#specs'
  get 'search/actions', to: 'search#actions'

  get 'spec/new', to: 'spec#new', as: :new_spec
  post 'spec/create', to: 'spec#create', as: :create_spec
  get 'spec/invite', to: 'spec#invite', as: :invite_spec
  post 'spec/create_invites', to: 'spec#create_invites', as: :create_spec_invites
  get 'spec/thanks', to: 'spec#thanks', as: :thanks_spec

  post 'spec/upload_document', to: 'spec#upload_document', as: :upload_document

  post 'spec/create_backup', to: 'backups#create', as: :create_backup

  #devise_for :accounts, path: '/users'
  #
  #devise_scope :account do
  #  get '/sign_in', to: 'sessions#new', as: :sign_in
  #  post '/sign_in', to: 'sessions#create', as: :sign_in_post
  #end

  resources :line_items, except: [:new, :edit]
  resources :building_materials, except: [:new, :edit]
  resources :documents, except: [:edit]
  resources :quotes, except: [:edit, :new, :delete]
  resources :sections, except: [:new, :edit]
  resources :actions, except: [:show, :edit, :delete]
  # This is an Item Specification not spec which is document above
  resources :specs, except: [:show, :edit, :delete]
  get 'app' => 'pages#app'
  get 'app/*path' => 'pages#app'
  get 'pages/*path' => 'pages#show'
  root to: 'pages#show', pathname: 'landing'
  get "*path" => "pages#show", pathname: '404'

  resources :backup_types, except: [:new, :edit]
  resources :state_types, except: [:new, :edit]
  resources :locations, except: [:new, :edit]
  resources :document_states, except: [:new, :edit]
  resources :documents, except: [:new, :edit]
end
