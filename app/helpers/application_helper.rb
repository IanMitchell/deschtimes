module ApplicationHelper
  def is_active?(*page_names, **keywords_args)
    unless keywords_args[:action].nil?
      return false if keywords_args[:action] != params[:action]
    end

    page_names.include? controller_name
  end

  # Allow Devise forms to be present anywhere
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
