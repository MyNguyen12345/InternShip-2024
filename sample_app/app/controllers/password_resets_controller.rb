class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end
  def update
    return render_empty_password if params[:user][:password].empty?
    return redirect_success if @user.update(user_params)

    render 'edit'
  end
  def edit
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  def get_user
    @user = User.find_by(email: params[:email])
  end
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset has expired.'
      redirect_to new_password_reset_url
    end
  end
  def render_empty_password
    @user.errors.add(:password, "can't be empty")
    render 'edit'
  end

  def redirect_success
    log_in @user
    @user.update_attribute(:reset_digest, nil)
    flash[:success] = 'Password has been reset.'
    redirect_to @user
  end
end
