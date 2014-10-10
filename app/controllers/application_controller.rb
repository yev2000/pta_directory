class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user_get, :logged_in?, :admin_logged_in?, :superadmin_logged_in?, :allow_object_edit?

  ########################
  #
  # Redirection
  #
  ########################

  def clear_original_action
    session[:prior_url] = nil
  end

  def redirect_from_root_for_logged_in
    # here we want to be smarter
    # if the user is logging in and does not have
    # any family defined, we can offer to help them
    if (logged_in? && current_user_get.families.size == 0)
      redirect_to freshuser_path 
    else
      redirect_to families_path
    end

  end


  def redirect_to_original_action
    if session[:prior_url]
      redirect_to session[:prior_url]
    else
      redirect_from_root_for_logged_in
    end
  end

  ########################
  #
  # User Management
  #
  ########################

  def current_user_get
    @current_user ||= User.find(session[:userid]) if session[:userid]
  end

  def logged_in?
    !!(current_user_get)
  end

  def admin_logged_in?
    logged_in? && (current_user_get.admin?  || current_user_get.superadmin?)
  end

  def superadmin_logged_in?
    logged_in? && (current_user_get.superadmin?)
  end

  def schooladmin_logged_in?
    logged_in? && (current_user_get.schooladmin?)
  end

  def current_user_clear
    @current_user = nil
  end

  def require_user
    if !logged_in?
      flash[:error] = "Must be logged in to do this"

      ## is there a way to know what the current path is, so
      ## that once we've logged in we can redirect to there?
      ## after having been redirecte to the login?
      session[:prior_url] = request.get? ? request.path : nil
      
      redirect_to login_path
    else
      clear_original_action
    end
  end

  def require_admin(path_var = root_path)
    access_denied(path_var) unless logged_in? && current_user_get.admin?
  end

  def require_schooladmin(path_var = root_path)
    access_denied(path_var) unless logged_in? && current_user_get.schooladmin?
  end

  def require_superadmin(path_var = root_path)
    access_denied(path_var) unless logged_in? && current_user_get.superadmin?
  end

  def allow_object_edit?(obj_var)
    # Can the object be edited by the currently logged in user?
    # Any object which has a "creator" field can be tested in this way
    # get_administator for the object may return nil which means no (non-admin) user can administer.  Therefore
    # important to check for current_user being logged in since otherwise nil==nil check can succeed.
    return false if obj_var.nil?
    current_user_get && ((current_user_get == obj_var.get_administrator) || (admin_logged_in?))
  end

  def access_denied(redirect_path, message_text = "You do not have enough privileges to perform this action.")
    flash[:error] = message_text
    redirect_to redirect_path
  end

end
