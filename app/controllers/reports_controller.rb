class ReportsController < AppController

  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_topic_if_exists, only: [:index, :new, :create]
  before_action :set_user_if_exists, only: [:index]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_user_by_report, only: [:edit, :update, :destroy]

  def index
    @reports = Report.includes(:topic, :user)
    if @topic.present?
      @reports = @reports.where(topic: @topic)
    end
    if @user.present?
      @reports = @reports.where(user: @user)
    end
  end

  def show
  end

  def new
    @report = Report.where(topic: @topic, user: current_user).first_or_initialize
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.reasons = params[:reasons]
    if @report.save
      redirect_to @report, notice: "Report was successfully created."
    else
      render action: "new"
    end
  end

  def edit
  end

  def update
    @report.assign_attributes(report_params)
    @report.reasons = params[:reasons]
    if @report.save
      redirect_to @report, notice: "Report was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    if @report.destroy
      redirect_to user_reports_path(current_user.account), notice: "Report was successfully deleted."
    else
      redirect_to @report, alert: "We are sorry, but something went wrong while deleting the report."
    end
  end


  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def report_params
    params.require(:report).permit(:topic_id, :detail)
  end

  def authenticate_user_by_report
    if !@report.by_user?(current_user)
      redirect_to root_path, alert: 'Permission denied.'
    end
  end


end
