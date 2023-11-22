class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy ]


  # GET /reports or /reports.json
  def index
    @q = Report.where(partner: Current.user.first_name).order(created_at: :desc).ransack(params[:q])
    @reports = @q.result(distinct: true)
    #reports = Report.all
  end

  # GET /reports/1 or /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)
    pattern = "localhost:3000/registrations/profile/"
    parts = params[:report][:user_id].partition(pattern)
    @report.partner =  Current.user.first_name
    if parts.include?(pattern)
      @report.user_id = parts.last
      @report.name = User.find_by(id: parts.last).first_name + " " + User.find_by(id: parts.last).last_name
    else
      @report.user_id = nil
    end

    respond_to do |format|
      if @report.save
        format.html { redirect_to report_url(@report), notice: "Report was successfully created." }
        format.json { render :show, status: :created, location: @report }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('report-form', partial: 'form'), status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: "Report was successfully updated." }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to reports_url, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:user_id, :partner, :name)
    end
end
