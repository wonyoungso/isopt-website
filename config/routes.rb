Rails.application.routes.draw do
  match 'login' => 'sessions#new', :via => :get
  match 'login' => 'sessions#create', :via => :post
  match 'logout' => 'sessions#destroy', :via => :get
  match 'logout' => 'sessions#destroy', :via => :delete
  match '/join' => 'users#new', :via => :get, :as => 'join'
  match '/:username' => 'users#show', :via => :get, :as => 'username'



  namespace :api do 

    match '/box/:sim_id/status', :to => 'user_devices#status', :via => :get
    match '/box/:sim_id/minuterecord/:minute_in_ms', :to => 'user_devices#minute_record', :via => :get
    match '/box/:sim_id/momentrecord/:moment_in_ms', :to => 'user_devices#moment_record', :via => :get

    resources :user_devices
    resources :users do
      resources :moment_records
      member do 
        post 'init_device'
        post 'press_btn'
      end
    end

    resources :event_isopts
  end

  namespace :admin do 
    resources :devices
    resources :user_devices do
      collection do 
        post 'assign'
      end
    end
     
    resources :event_isopts do
      member do 
        post 'activate'
        post 'ended' 
        get 'devices_table'
        post 'reset'
        post 'publish'
        post 'unpublish'
      end
    end
     
    resources :users do 
      resources :u_user_devices
      resources :moment_records
      collection do 
        get 'search'
        get 'event_isopt'
      end

      member do 
        patch 'update_init_time'
        patch 'deinitialize'
      end
    end

    match 'login' => 'sessions#new', :via => :get
    match 'login' => 'sessions#create', :via => :post
    match 'logout' => 'sessions#destroy', :via => :delete

    root 'users#index'
  end

  resources :users
  resources :event_isopts

  
  root 'welcome#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
