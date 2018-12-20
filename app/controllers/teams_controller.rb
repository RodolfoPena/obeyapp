class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = Team.all
    @team = Team.new
    @users = User.all
    @target = Target.new
    @commitment = Commitment.new
  end

  def new
    @team = Team.new
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
        format.html { redirect_to teams_path, notice: 'Team was successfully created'}
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { redirect_to new_team_path, alert: 'Error terrible compadre!'}
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
    # respond_to do |format|
    #   format.js {render 'team/edit'}
    # end
  end

  def update
    @team = Team.find(params[:id])
    users = User.find(params[:team][:member_ids].each(&:to_i))
    @team.user_members.destroy_all
    users.each do |user|
      @team.user_members << user
    end
    @team.update(team_params)
    redirect_to teams_path
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_path, notice: 'Team was successfully destroyed.'}
      format.json { head :no_content }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description)
  end

  # def member_ids
  #   params.require(:team).permit(member_ids: [])
  # end

end
