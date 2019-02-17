Rails.application.routes.draw do
  root to: "lists#index"
  resources :lists, except: [:edit] do
    resources :todos, only: [:create, :edit, :update, :destroy] do
      collection do
        delete :clear_completed, to: "todos#clear_completed", as: "clear"
      end
      member do
        patch :complete, to: "todos#complete"
      end
    end
  end
end
