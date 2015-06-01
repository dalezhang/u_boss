#encoding:utf-8
class UserMailer < ActionMailer::Base
  default from: "system@musichttp.com"
  def user_notify_email(comment)
    @comment = comment
    @url = post_url(@comment.post, host: 'localhost')
    mail to: 'admin@musichttp.com', subject: 'There is a new comment on your blog'
  end

  def sendmail(email_to, sender_name, subject, message)
    @message = message
    @sender = sender_name
    @subject = subject
    if !email_to.blank?
      mail(:subject => "#{subject}", :from=>"system@musichttp.com",:cc => email_to) do |format|
        format.html
      end
    end
  end


end