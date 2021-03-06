#encoding:utf-8
require 'digest/sha1'
class User < ActiveRecord::Base
  attr_accessor   :password, :password_confirmation, :old_password

	before_save :encrypt_password
  before_save :remember_me
  before_save :create_user_purse
  validates :name,presence: true,length:{maximum: 50},uniqueness: { case_sensitive: true }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true,
  format:{with:VALID_EMAIL_REGEX},
  uniqueness: { case_sensitive: false }
  validates :password, :confirmation=> { :allow_blank=> true }, :length=>{:maximum=>20,:minimum=>6} ,:if => :password_required?
  has_many :audios, :dependent => :destroy
  has_one  :user_purse
  has_one  :asset_logo, :class_name => "AssetLogo", :as => :resource, :dependent => :destroy #logo，只有一个
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  before_save {|user| user.email = email.downcase}


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def authenticate(password)
    self.authenticated?(password) ? self : nil
  end
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    # save(:validate => false)
  end
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{remember_token_expires_at}")
    # save(:validate => false)
  end
  protected
	def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  
  private
    def create_remember_token
     self.remember_token = SecureRandom.urlsafe_base64
    end
    def create_user_purse
      unless self.user_purse.present?
        UserPurse.create(:user_id=>self.id)
      end
    end
end