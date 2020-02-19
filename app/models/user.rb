class User < ApplicationRecord
  validates_uniqueness_of :email

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :email,
                        :password_digest

  has_secure_password

  def duplicate_email?(email)
    User.pluck(:email).include?(email)
  end
end