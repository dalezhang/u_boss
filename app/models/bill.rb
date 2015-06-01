#encoding:utf-8
class Bill < ActiveRecord::Base
  belongs_to :user
end
