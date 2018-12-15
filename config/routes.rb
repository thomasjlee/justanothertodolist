Rails.application.routes.draw do
  root to: "todo_lists#index"
  resources :todo_lists do
    resources :todo_items, only: [:create, :edit, :update, :destroy] do
      collection do
        delete :clear_completed, to: "todo_items#clear_completed", as: "clear"
      end
    end
  end
end
