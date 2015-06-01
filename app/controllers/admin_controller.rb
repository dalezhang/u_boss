#encoding:utf-8
class  AdminController < BaseController
  before_filter :admin_user,:signed_in_user
  def index
    
  end
  def check_enter_code
    encode_str = Time.now.to_date.strftime('%Y-%m-%d')
    dynamic_code1 = Digest::MD5.hexdigest("#{encode_str}-tp0")
    dynamic_code2 = Digest::MD5.hexdigest("#{encode_str}-tp1")
    if params[:admin][:enter_code] == dynamic_code1
      @cards = RechargeableCard.where(:status=>0)
      @tp=0
    elsif params[:admin][:enter_code] == dynamic_code2
      @cards = RechargeableCard.where(:status=>1)
      @tp=1
    end
    puts params
    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end
  end
  def admin_user
    if current_user.present? and current_user.email = "2996190192@qq.com"
      return true
    else
      redirect_to :controller=>:audio,:action=>:index
    end
  end
end