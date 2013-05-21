Golden::Setting::Engine.routes.draw do
  resources :settings do
    collection do
      get :list
      put :batch_update
    end
  end
end
