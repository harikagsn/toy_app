class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
                                attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
has_secure_password
validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
def remember
  remember_token = new_token
  update_attribute(:remember_digest, User.digest(remember_token))
end
class << self
def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(remember)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember)
  end
  def forget
    update_attribute(:remember_digest, nil)
  end
end
def feed
    Micropost.where("user_id = ?", id)
  end
  def follow(other_user)
      following << other_user
    end

    # Unfollows a user.
    def unfollow(other_user)
      following.delete(other_user)
    end

    # Returns true if the current user is following the other user.
    def following?(other_user)
      following.include?(other_user)
    end
private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
