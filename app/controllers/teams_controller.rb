class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, except: [:index, :new, :create]

  def index
    @teams = Team.all
    @team = Team.new
    @users = User.all
    @target = Target.new
    @commitment = Commitment.new
    @tab = params[:tab]
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
        format.html { redirect_to teams_url(tab: "teams"), notice: 'Team was successfully created'}
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { redirect_to new_team_path, alert: 'Error terrible compadre!'}
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    users = User.find(params[:team][:member_ids].each(&:to_i))
    @team.user_members.destroy_all
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

  def target_params
    params.require(:target).permit(:title, :description, :start_date, :due_date, :responsible_id, :team_id)
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end

  # def member_ids
  #   params.require(:team).permit(member_ids: [])
  # end

end
