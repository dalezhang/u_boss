module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token # the same as cookies[:remember_token] = { value: user.remember_token, expires: 20.years.from now.utc }
    self.current_user = user
  end
  
  def signed_in?
    current_user != nil
  end

  def current_user=(user)
    @current_user = user
  end
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  def current_user?(user)
    user == current_user
  end
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to :controller=>"/sessions",:action=>:new unless signed_in?
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  def store_location
    session[:return_to] = request.fullpath
  end
  private
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
    def admin_user
      if current_user.email = "2996190192@qq.com"
        return true
      else
        redirect_to :controller=>:audio,:action=>:index
      end
    end
end