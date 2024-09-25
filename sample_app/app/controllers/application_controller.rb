class ApplicationController < ActionController::Base
  include SessionsHelper
  # rescue_from ActiveRecord::RecordNotFound, :with=> :record_not_found
  def load_user
    @user = User.find_by(id: params[:id])
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to(root_url, flash: {danger: 'You are not authorized to access this page.'}) unless current_user?(@user) || @micropost
  end

  private

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  # def record_not_found
  #   render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  # end
end
