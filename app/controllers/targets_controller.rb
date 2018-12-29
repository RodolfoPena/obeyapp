class TargetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target, except: [:create, :nested_create]


  def create
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
        format.html { redirect_to "#{teams_path}#targets", notice: 'Target was successfully created'}
        format.json { render json: @target, status: :created, location: @target }
      else
        format.html { redirect_to new_target_path, alert: 'Unprocessable entity'}
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  def nested_create
    @target = Target.new(target_params)
    @target.user = current_user
    @target.start_date = Date.today
    if params[:target][:responsible_id].nil?
      @target.responsible = nil
    else
      user = User.find(params[:target][:responsible_id].to_i)
      @target.responsible = user
    end
    @target.team = Team.find(params[:team_id])
    respond_to do |format|
      if @target.save
        format.html { redirect_to team_path(@target.team.id), notice: 'Target was successfully created'}
        format.json { render json: @target, status: :created, location: @target }
      else
        format.html { redirect_to new_target_path, alert: 'Unprocessable entity'}
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @target.update(target_params)
    redirect_to teams_path
  end

  def destroy
    @target.commitments.each do |commitment|
      commitment.destroy
    end
    @target.destroy
    redirect_to teams_path
  end

  private

  def set_target
    @target = Target.find(params[:id])
  end
  
  def target_params
    params.require(:target).permit(:title, :description, :start_date, :due_date, :responsible_id, :team_id)
  end

end
