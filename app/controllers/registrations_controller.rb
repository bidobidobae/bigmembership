class RegistrationsController < ApplicationController
  before_action :authenticate, only: [:profile, :edit, :update, :index]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      send_email_verification
      redirect_to root_path, notice: "Welcome! You have signed up successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def profile
    @user = User.find(params[:id]) 
    @reports = @user.reports.order(created_at: "DESC")
  end

  def index
    @q = User.where.not(role: "admin").ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def edit
    @user = User.find(params[:id]) 
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone, :qrcode, :active_date, :expired_date, :birth_date))
        format.html { redirect_to root_path, notice: "User has been updated" }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        #format.turbo_stream { render turbo_stream.replace('user-form', partial: 'form'), status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone, :qrcode, :active_date, :expired_date, :birth_date)
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
