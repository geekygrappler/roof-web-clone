Rails.application.routes.draw do
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
