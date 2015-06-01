#encoding:utf-8
class  WeixinPayController < ManageController
	# def create
 #    puts params
 #    @bill = Bill.new
 #    @bill.price = params[:bill][:money]
 #    @bill.trade_no = "SO#{Time.now.strftime('%Y%m%d%H%M%S')}_#{current_user.id}"
 #    @bill.user_id = current_user.id
 #    if @bill.save
 #      # 向微信提交预支付请求
 #      result = WeixinPay.prev_pay("#{current_user.name}", @bill.trade_no, @bill.price,
 #                                  "#{request.protocol}#{request.host_with_port}/pay_api/weixin_notify")
 #      if result.present? && result['return_code'].eql?('SUCCESS') && result['result_code'].eql?('SUCCESS') && result['prepay_id'].present?
 #        @bill.update_attribute(:prepayid, result['prepay_id'])
 #        flash[:success] = '订单创建成功。'
 #      else
 #        @bill.destroy
 #        flash[:error] = '订单创建失败。'
 #        redirect_to :action => :new
 #      end
 #    else
 #      flash[:error] = '订单创建失败。'
 #    end
 #    redirect_to :action => :pay,:id=>@bill.id
 #  end
end

