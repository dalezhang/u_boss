#encoding:utf-8
class Console::BaseController < BaseController
  before_filter :signed_in_user
  def index
  end
end