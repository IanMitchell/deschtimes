class HomeController < ApplicationController
  layout 'base'

  def index
    redirect_to groups_url if user_signed_in?
  end
end
