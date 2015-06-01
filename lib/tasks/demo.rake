#encodeing:utf-8
# 添加demo数据
# namespace :db do
# 	desc "create demo data"
# 	task :demo=> :environment do
#     puts "测试用户"
#     #添加6个学生
#     (1..60).to_a.each do |i|
#       user = User.create!(:email=>"user#{i}@mail.com",:name=>"用户#{i}",:password=>"111111",:password_confirmation=>"111111")
#       print "."
#     end
#     puts "demo添加完毕."
#   end
# end

require 'ffaker'
# I18n.reload!
# Faker::Config.locale = :"zh-CN"
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # make_users
    make_microposts
    make_relationships
    puts "demo添加完毕."
  end
  task create_cards: :environment do
    puts "开始创建卡"
    30.times {make_rechargeable_cards(5)}
    10.times {make_rechargeable_cards(10)}
    5.times {make_rechargeable_cards(50)}
  end
  
end

def make_users
  admin = User.create!(name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar")
  admin.toggle!(:admin)
  
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "foobar"
    User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password)
  end
end
def make_microposts
  users = User.where(true)[0..6]
  50.times do
    content = Faker::Lorem.sentence
    users.each {|user| user.microposts.create!(content: content)}
  end
end
def make_relationships
  user = User.first
  users = User.where(true)[0..6]
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each {|followed| user.follow!(followed)}
  followers.each {|follower| follower.follow!(user)}
end

def make_rechargeable_cards(type=5)
  type=type.to_i
  if [5,10,50].include?(type)
    uuid = UUIDTools::UUID.random_create.to_s.gsub!('-','')
    RechargeableCard.create(:uuid=>uuid[0..10],:card_type=>type,:golds=>type*10)
  end
end
