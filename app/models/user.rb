class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :first_name_kana, :last_name, :last_name_kana_string, :password_digest
end
