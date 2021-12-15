class Hws::Connectors::WebhooksController < ApplicationController
  protect_from_forgery

  protected

  def render_response(response)
    entity = Hws::Connectors::Dto::Entity.new(name: params['entity'])
    Hws::Connectors.webhooks.to_h[params['controller'].split('/').last].to_h[params['action']].try(:call, entity, response)
    render status: 200, json: { success: true, message: 'success' }
  end
end
