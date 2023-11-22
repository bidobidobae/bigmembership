class PassthroughController < ApplicationController
  before_action :authenticate

  def index
    path = case Current.user.role
      when 'admin'
        admin_path
      when 'member'
        profile_path(Current.user)
      else
        # If you want to raise an exception or have a default root for users without roles
        sign_in_path
    end

    redirect_to path     
  end
end
