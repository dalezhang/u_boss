#encoding:utf-8
class  UserPurseController < ManageController
  before_filter :signed_in_user
  def recharge_page
    @user = current_user
  end
  def recharge
    user_purse = current_user.try(:user_purse)
    if params[:rechargeable_card].present? and params[:rechargeable_card][:uuid].present?
      card = RechargeableCard.find_by_uuid(params[:rechargeable_card][:uuid]) rescue nil
      if card.present?
        if card.status == 0 and user_purse.present?
        
          golds =user_purse.try(:golds).try(:to_f)
          golds += card.golds
          card.update_attributes(:user_id=>current_user.id,:status=>1)
          user_purse.update_attributes(:golds=>golds)
          flash[:success] = "成功充值#{'%.2f' % card.golds.to_f}个金币,您的账户现在共有金币#{'%.2f' % user_purse.golds}个"
        else
          flash[:error] = "该充值码已经被使用，请换一个充值码再尝试。"
        end
      else
        flash[:error] = "充值码输入错误，请重新输入。"
      end
    else
      flash[:error] = "请输入充值码"
    end
    redirect_to :action=>:recharge_page
  end
  def recharge_histroy
    @cards=RechargeableCard.where(:user_id=>current_user.id).order("updated_at DESC")
    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end
  end

end