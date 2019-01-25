class TargetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target, except: [:create, :nested_create, :index]

  def index
    @target = Target.new
    @users = User.all
    @tab = params[:tab]
  end

  def create
    byebug
    @target = Target.new(target_params)
    @target.user = current_user
    @target.start_date = Date.today
    if params[:target][:responsible_id].nil?
      @target.responsible = nil
    else
      user = User.find(params[:target][:responsible_id].to_i)
      @target.responsible = user
    end
    respond_to do |format|
      if @target.save
        format.html { redirect_to teams_url(tab: "targets"), notice: 'Target was successfully created'}
        format.json { render json: @target, status: :created, location: @target }
      else
        format.html { redirect_to teams_url(tab: "targets"), alert: 'Unprocessable entity'}
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @users = User.all
  end

  def edit
  end

  def update
    byebug
    @target.update(target_params)
    redirect_to teams_url(tab: "targets")
  end

  def destroy
    @target.commitments.each do |commitment|
      commitment.tasks.each do |task|
        task.destroy
      end
      commitment.destroy
    end
    @target.destroy
    target_path(@target, tab: "projects")
  end

  private

  def set_target
    @target = Target.find(params[:id])
  end

  def target_params
    params.require(:target).permit(:title, :description, :start_date, :due_date, :responsible_id, :team_id)
  end

end
