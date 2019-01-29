class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, except: [:index, :new, :create]

  def index
    @team = Team.new
    @teams = Team.all
    @users = User.all
    @tab = params[:tab]
  end

  def new
    @team = Team.new
    @users = User.all
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    users = User.find(params[:team][:member_ids].each(&:to_i))
    users.each do |user|
      @team.user_members << user
    end
    respond_to do |format|
      if @team.save
        format.html { redirect_to teams_url(tab: "teams"), notice: 'Team was successfully created'}
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { redirect_to teams_url(tab: "teams"), alert: 'Unprocessable entity'}
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @tab = params[:tab]
    @users = User.all
  end

  def edit
  end

  def update
    @team.user_members.destroy_all
    users = User.find(params[:team][:member_ids].each(&:to_i))
    users.each do |user|
      @team.user_members << user
    end
    @team.update(team_params)
    redirect_to teams_url(tab: "teams")
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url(tab: "teams"), alert: 'Team was successfully destroyed'}
      format.json { head :no_content }
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
