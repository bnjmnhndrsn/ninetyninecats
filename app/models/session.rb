class Session < ActiveRecord::Base
  belongs_to :user
  
  def generate_session_token!
    self.session_token = SecureRandom.urlsafe_base64
  end
end
