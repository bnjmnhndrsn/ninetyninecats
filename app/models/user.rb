class User < ActiveRecord::Base
  attr_reader :password
  
  validates :user_name, :password_digest, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  
  has_many :cats
  has_many :cat_rental_requests
  has_many :sessions
  
  
  def password=(word)
    @password = word
    self.password_digest = BCrypt::Password.create(word)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user &&  user.is_password?(password)
    nil
    
  end
  
end
