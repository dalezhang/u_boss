class MicropostsController < BaseController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: [:destroy]
  
  def new
    @micropost = Micropost.new
  end
  def create
  	@micropost = current_user.microposts.build(micropost_params)
  	if @micropost.save
  		flash[:success] = "消息发布成功!"
  		redirect_to :controller=>:users,:action=>:show,:id=>current_user.id
  	else
  		@feed_items = []
  		render 'static_pages/home'
  	end
  end
  def destroy
  	@micropost.destroy
  	redirect_to @micropost.user
  end
  private
    def correct_user
    	@micropost = current_user.microposts.find_by_id(params[:id])
    	redirect_to root_path if @micropost.nil?
    end
    def micropost_params
      if params[:micropost].present?
        params.require(:micropost).permit(:content)
      end
    end
end