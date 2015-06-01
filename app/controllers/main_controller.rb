#encoding:utf-8
class  MainController < BaseController
	def index
    @microposts = Micropost.where(true).order("updated_at DESC").paginate(:page => params[:page], :per_page => 10)
		# if current_user.present?
  #     redirect_to :controller=>:audios,:action=>:index
  #   else
  #     redirect_to :controller=>:sessions,:action=>:new
  #   end
  end
end