class CommitmentsController < ApplicationController
  before_action :authenticate_user!
  def new
  end

  def create
    @commitment = Commitment.new(commitment_params)
    @commitment.user = current_user
    @commitment.responsible = User.find(params[:commitment][:responsible_id].to_i)
    respond_to do |format|
      if @commitment.save
        format.html { redirect_to teams_path(tab: '#commitment'), notice: 'Commitment was successfully created'}
        format.json { render json: @commitment, status: :created, location: @commitment }
      else
        format.html { redirect_to new_commitment_path, alert: 'Unprocessable entity'}
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  private def commitment_params
    params.require(:commitment).permit(:action, :conditions_of_satisfaction, :start_date, :due_date, :target_id, :responsible_id )
  end

end
