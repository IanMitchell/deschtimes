class ApplicationController < ActionController::Base
  layout :auth_layout
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, alert: "You don't have permission to view that!"
  end

  def authenticate_group!
    unless current_user.groups.exists? @group.id
      redirect_to root_url, alert: "You are not an admin for #{@group.name}"
    end
  end

  def set_group
    @group = current_user.groups.friendly.find(params[:group_id])
  end

  def set_show
    @show = @group.shows.find(params[:show_id])
  end

  def set_episode
    @episode = @show.episodes.find(params[:episode_id])
  end

  def add_breadcrumb(name, url)
    @breadcrumbs ||= []
    @breadcrumbs << [name, url]
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  protected
    def configure_permitted_parameters
      added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

  private
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end

    def auth_layout
      if devise_controller?
        "auth"
      else
        "application"
      end
    end
end
