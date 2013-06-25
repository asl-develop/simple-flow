class User < ActiveRecord::Base
  has_many :tasks
  has_many :task_logs
  
  attr_accessible :email, :name, :name_kana, :password_digest, :login_id

# TODO 指定ユーザー以外
#  scope :exclude, ->(user){ where(user_id: user.id)}




  class << self

    def authenticate(login_id, password)
      user = find_by_login_id(login_id)
      
      if user.present? && 
        user.password_digest == password
        #BCrypt::Password.new(shop.password_digest) == password
        return user
      else
        return nil
      end
    end
    
  end


end
