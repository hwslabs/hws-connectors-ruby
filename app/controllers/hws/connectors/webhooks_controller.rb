class Hws::Connectors::WebhooksController < ApplicationController
  protect_from_forgery

  META_RESPONSES = %w(entity)
end
