class ProblemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_problem, except: [:create, :index]

  def index
    @problem = Problem.new
    @users = User.all
  end

  def create
    @problem = Problem.new(problem_params)
    @problem.user = current_user
    respond_to do |format|
      if @problem.save
        format.html { redirect_to problems_url, notice: 'Problem was successfully created'}
        format.json { render json: @problem, status: :created, location: @problem }
      else
        format.html { redirect_to problems_url, alert: 'Unprocessable entity'}
        format.json { render json: @problem.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:title, :description, :type, :status, :status_update, :target_id, causes_attributes: [:name])
  end
end
