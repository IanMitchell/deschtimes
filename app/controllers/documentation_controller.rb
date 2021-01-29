class DocumentationController < ApplicationController
  before_action do
    add_breadcrumb "Documentation", documentation_url
  end

  def index
  end

  def discord
  end

  def api
  end

  def webhooks
  end
end
