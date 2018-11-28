Rails.application.routes.draw do
  root to: "todo_lists#index"
  resources :todo_lists do
    resources :todo_items, only: [:create, :update, :destroy] do
      member do
        patch :complete
      end
      collection do
        post :clear_completed, to: "todo_items#clear_completed", as: "clear"
      end
    end
  end
end
