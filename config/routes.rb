Rails.application.routes.draw do
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
  root :to => 'main#index'
  resources :main
  resources :microposts, only: [:new,:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
    get :show_follow, :on => :collection
    post :add_avatar, :on=>:collection
  end
  resources :admin do
    post :check_enter_code,:on=>:collection
  end
  resources :sessions do
    get :active_user,:try_to_reset_password,:reset_password, :on=>:collection
    post :send_reset_password_email, :on=>:collection
  end
  resources :user_purse do
    get :recharge_page,:recharge_histroy, :on=>:collection
    post :recharge, :on=>:collection
  end
  resources :weixin_pay
  match '/signup', to: "users#new",via: [:get, :post]
  match '/signin', to: "sessions#new",via: [:get, :post]
  match '/signout', to: "sessions#destroy", via: :delete
  # 后台管理系统
  match '/console', to: 'console/main#index',via: :get
  namespace :console do
    resources :post_products do
    end
  end
end
