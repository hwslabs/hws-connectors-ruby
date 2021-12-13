Rails.application.routes.draw do
  namespace :hws do
    namespace :connectors do
      resource :payouts, only: :none do
        collection { post ':bank/callback', action: :callback }
      end
      resource :virtual_accounts, only: :none do
        collection { post ':bank/notify', action: :notify }
      end
    end
  end
end
