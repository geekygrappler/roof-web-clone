RoofApi::Engine.routes.draw do
  devise_for :accounts, path: '/auth', controllers: {
    sessions: 'auth/sessions',
    registrations: 'auth/registrations',
    passwords: 'auth/passwords'
  }
  devise_scope :account do
    get '/auth/csrf_token' => 'auth/sessions#csrf_token'
    post '/auth/impersonate' => 'auth/sessions#impersonate'
    delete '/auth/impersonate' => 'auth/sessions#stop_impersonate'
  end

  resources :invitations, only: [] do
    post :accept, on: :collection
  end
  resources :leads, only: [:create]
  resources :assets, only: [:create, :destroy]
  authenticate do
    resources :assets, except: [:create, :destroy, :edit, :update]
    resources :projects, except: [:edit] do
      resources :assets, except: [:edit]
      put :add_to_membership, on: :member
      put :remove_from_membership, on: :member
    end
    resources :professionals, except: [:create, :edit]
    resources :customers, except: [:create, :edit]
    resources :administrators, except: [:create, :edit]
    resources :appointments, except: [:edit]

    resources :materials, except: [:edit] do
      match 'search', action: 'index', on: :collection, via: [:get, :post]
    end
    resources :tasks, except: [:edit] do
      match 'search', action: 'index', on: :collection, via: [:get, :post]
    end
    resources :tender_templates, except: [:edit]
    resources :tenders, except: [:edit]
    resources :quotes, except: [:edit] do
      put 'accept', on: :member
      put 'submit', on: :member
    end
    resources :payments, except: [:edit] do
      put 'approve', on: :member
      delete 'cancel', on: :member
      post 'pay', on: :member
      post 'refund', on: :member
    end
    resources :leads, except: [:create, :edit]
    resources :invitations, except: [:accept, :create, :update, :edit] do
      post :invite, on: :collection
    end
    resources :accounts, except: [:edit]
    resources :comments, except: [:edit]
    namespace :content do
      resources :templates, except: [:edit]
      resources :pages, except: [:edit]
    end
  end

end
