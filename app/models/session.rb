class Session < ApplicationRecord
  belongs_to :user

  kredis_flag :sudo, expires_in: 30.minutes

  before_create do
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end

  after_create { sudo.mark }
end
