class TargetsController < ApplicationController
  before_action :authenticate_user!

  def create
    byebug
    @target = Target.new(target_params)
    @target.user = current_user
    if params[:target][:responsible_id].nil?
      user = User.find(params[:target][:responsible_id].to_i)
      @target.responsible = user
    end
    respond_to do |format|
      if @target.save
        format.html { redirect_to teams_path(tab: 'targets'), notice: 'Target was successfully created'}
        format.json { render json: @target, status: :created, location: @target }
      else
        format.html { redirect_to new_target_path, alert: 'Unprocessable entity'}
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @target = Target.find(params[:id])
  end

  def update
    @target = Target.find(params[:id])
    @target.update(target_params)
    redirect_to teams_path
  end

  def destroy
    @target = Target.find(params[:id])
    @target.destroy
  end

  private def target_params
    params.require(:target).permit(:title, :description, :start_date, :due_date, :team_id, :responsible_id)
  end

end
