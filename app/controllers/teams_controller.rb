class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = Team.all
    @team = Team.new
    @users =  User.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    respond_to do |format|
      if @team.save
        format.html { redirect_to teams_path, notice: 'Team was successfully created'}
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { redirect_to new_team_path, alert: 'Impossible' }
        format.json { render json @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update(team_params)
    redirect_to teams_path
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_path, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description)
  end

end
