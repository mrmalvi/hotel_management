class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActiveStorage::SetCurrent
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  helper_method :current_platform

  private

  def current_platform
    # Replace this with your actual logic to determine the current platform
    @current_platform ||= Platform.first
  end
end
