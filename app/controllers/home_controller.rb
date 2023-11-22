class HomeController < ApplicationController
  before_action :authenticate

  def index
    @q = Report.where(partner: Current.user.first_name).order(created_at: :desc).ransack(params[:q])
    @reports = @q.result(distinct: true)
    #@reports = Current.user.reports.order(created_at: "DESC")  
  end

end
