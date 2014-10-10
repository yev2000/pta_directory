class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]
  before_action :require_logged_in_user_or_superadmin, only: [:edit, :update, :admin_edit]
  
  def new
    @user = User.new
  end

  def create

    @user = User.new(user_params)
    
    if (password_confirm!(@user) && @user.save)
      flash[:notice] = "Your user account (for #{@user.username}) was created.  You are logged in."

      # if we want to log the user in, we simply create
      # a session for the user implicitly.
      session[:userid] = @user.id

      redirect_to root_path
    else
      render :new
    end

  end

  def edit
    # fix up the role in those cases where role is missing
    # by default if role is empty, we will call that just the user role.
    @user.role = @user.roles_hash[:user] if @user.role.nil? || @user.role.size < 1
  end

  def admin_edit
    user = User.find_by(slug: params[:id])
    if (user.nil?)
      flash[:notice] = "No user for #{params[:id]} was found."
      redirect_to root_path
    else
      redirect_to edit_user_path(user)
    end
  end

  def update
    # if password was supplied, then set it
    if (password_confirm!(@user) && @user.update(user_params) && @user.valid?)
      # (will validations make sure duplicate username is not set?)
      flash[:notice] = "The account for \"#{@user.username}\" was updated."
      redirect_to user_path(@user)
    else
      render :edit
    end     
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :email, :role)
  end

  def set_current_user
    @user = current_user_get
  end

  def set_user
    @user = User.find_by(slug: params[:id])
    if @user.nil? 
      flash[:notice] = "There is no user account for #{params[:id]}." 
      redirect_to root_path
    end
  end

  def require_logged_in_user_or_superadmin
    if (@user != current_user_get) && (! superadmin_logged_in?)
      flash[:error] = "You cannot edit a different user's profile"
      redirect_to root_path
    end
  end

  def password_confirm!(user)
    if (params[:user][:password] && (params[:user][:password] != params[:user][:password_confirm]))
      # user's password confirmation field did not match
      user.errors.add(:password, "Confirmation did not match.  Your password and password confirmation must match.")
      return false
    else
      return true
    end
  end

end

