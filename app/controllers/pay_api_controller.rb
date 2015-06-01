#encoding:utf-8
class PayApiController < ApplicationController
  protect_from_forgery :except => [:notify, :sms_notify, :weixin_alarm, :weixin_notify]

  # 订单支付后台通知结果反馈
  def notify
    result = 'fail'
    if check_url # 验证url真伪
      # 交易成功 && 订单号不为空
      if params[:trade_state].eql?('0') && params[:out_trade_no].present? && params[:notify_id].present?
        if YearbookOrder.check_notify_id(params[:notify_id]) # 向财付通发送请求验证订单有效
          @order = YearbookOrder.find_by_trade_no(params[:out_trade_no])
          if @order.present? # 订单存在
            if @order.tp == 0 # 未支付
              if @order.update_attribute(:tp, 1)
                @order.yearbook_order_logs.create!({:operate => 1}) # 记录日志
              end
            end
            result = 'success' # 返回成功信息给财付通
          end
        end
      end
    end
    render :text => result
  end

  def sms_notify
    result = 'fail'
    if check_url # 验证url真伪
      # 交易成功 && 订单号不为空
      if params[:trade_state].eql?('0') && params[:out_trade_no].present? && params[:notify_id].present?
        if YearbookOrder.check_notify_id(params[:notify_id]) # 向财付通发送请求验证订单有效
          @order = SmsOrder.find_by_trade_no(params[:out_trade_no])
          if @order.present? # 订单存在
            if @order.tp == 0 # 未支付
              if @order.update_attribute(:tp, 1)
                # 创建短信充值记录
                msm_log = SmsLog.new(:count => @order.sms_count * @order.order_count,
                                     :kindergarten_id => @order.kindergarten_id,
                                     :user_id => @order.user_id, :tp => 5,
                                     :note=>"用户充值#{@order.sms_count * @order.order_count}条")
                msm_log.save
                @order.update_attribute(:sms_log_id, msm_log.id)
              end
            end
            result = 'success' # 返回成功信息给财付通
          end
        end
      end
    end
    render :text => result
  end

  # 告警通知处理
  def weixin_alarm
    p params
    render :text => 'SUCCESS'
  end

  # 微信后台支付通知
  def weixin_notify
    if params['xml'].present? && params['xml']['result_code'].eql?('SUCCESS') &&
        params['xml']['return_code'].eql?('SUCCESS') && # 业务完成
        params['xml']['appid'].eql?(WEIXIN_PAY[:appId]) &&
        params['xml']['mch_id'].eql?(WEIXIN_PAY[:mchid]) # 商户信息
      options = params['xml']
      sign = options.delete('sign')
      origin_sign = WeixinPay.encode(options)
      if origin_sign.eql?(sign) # 验证签名是否正常
        @order = Bill.find_by_trade_no(options['out_trade_no']) # 根据订单号查询
        if @order.present? && @order.tp == 0 # 未支付订单存在
          if @order.update_attribute(:tp, 1)
            @order.yearbook_order_logs.create!({:operate => 1}) # 记录日志
          end
        end
      end
    end
    render :text => 'SUCCESS'
  end

  private

  # 测试外部访问是否合法
  def check_url
    sign = params[:sign] # 进入的请求包含签名
    params.delete_if {|param| %w(sign action controller).include? param}
    origin_sign = YearbookOrder.get_sign(params)
    origin_sign.eql?(sign) # 验证传递进来到sign是否和本地得到的sign相同
  end

end
