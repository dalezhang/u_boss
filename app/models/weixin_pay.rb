#encoding:utf-8
# 微信支付模块
class WeixinPay
  class << self
    # 预支付
    def prev_pay(order_name, trade_no, fee, notify_url)
      url = 'https://api.mch.weixin.qq.com/pay/unifiedorder'
      options = {}
      options['appid'] = WEIXIN_PAY[:appId]
      options['mch_id'] = WEIXIN_PAY[:mchid]
      options['nonce_str'] = ('a'..'z').to_a.shuffle[0..10].join('')
      options['body'] = order_name
      options['out_trade_no'] = trade_no
      options['total_fee'] = fee.to_i
      options['notify_url'] = notify_url
      options['trade_type'] = 'JSAPI'
      options['spbill_create_ip'] = '192.168.20.10'
      sign = encode(options) # 生成密钥
      options['sign'] = sign
      params = options.to_xml(:dasherize => false, :skip_instruct => true).gsub('hash>', 'xml>')
      result = RestClient.post url, params, :content_type => :xml, :accept => :xml
      if result.present?
        Hash.from_xml(result)['xml']
      else
        {}
      end
    end

    # 获取参数加密信息
    def encode(options = {})
      str_arr = []
      # 待签名参数按照字段名的ascii码从小到大排序后使用QueryString的格式拼接而成，空值不传递，不参与签名。
      options.keys.sort.each do |key|
        str_arr << "#{key}=#{options[key]}"
      end
      url_params = str_arr.join('&')
      # sign = Md5(原字符串&key=商户密钥).upcase
      encode_str = url_params + '&key=' + WEIXIN_PAY[:key] # 商户密钥
      Digest::MD5.hexdigest(encode_str).upcase
    end
  end
end