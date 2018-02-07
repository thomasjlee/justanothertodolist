Rails.application.routes.draw do
  root to: "todo_lists#index"

  resources :todo_lists do
    post "clear_completed", to: "todo_items#clear_completed"

    resources :todo_items do
      member do
        patch :complete
      end
    end
  end
end
