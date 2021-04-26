Rails.application.routes.draw do
  Rails.application.routes.draw do
    resources :users do
      resources :events
    end
  end
end
