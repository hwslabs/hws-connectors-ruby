Rails.application.routes.draw do
  namespace :hws do
    namespace :connectors do
      resource :payouts, only: :none do
        collection { post ':bank/webhook', action: :webhook }
      end
    end
  end
end
