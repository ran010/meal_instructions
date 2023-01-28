class ApplicationController < ActionController::Base
  include Sortable
  include Pagy::Backend

  layout :set_layout

  def current_controller?(names)
    return false if params[:controller].blank?
    names.include?(params[:controller])
  end
  helper_method :current_controller?

  protected
  def after_sign_in_path_for(resource_or_scope)
    root_path
  end
  private

  def set_layout
    if devise_controller? && action_name != "edit"
      "devise"
    elsif user_signed_in?
      "application"
    else
      "static"
    end
  end
end
