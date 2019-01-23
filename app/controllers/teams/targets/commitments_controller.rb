class Teams::Targets::CommitmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commitment, except: [:create, :nested_create, :index]
  include CommitmentsHelper

  def create
    @commitment = Commitment.new(commitment_params)
    @commitment.user = current_user
    @commitment.start_date = Date.today
    @commitment.responsible = User.find(params[:commitment][:responsible_id].to_i)
    @commitment.target = Target.find(params[:target_id])
    set_status(@commitment)
    respond_to do |format|
      if @commitment.save
        format.html { redirect_to target_path(@commitment.target_id), notice: 'Commitment was successfully created'}
        format.json { render json: @commitment, status: :created, location: @commitment }
      else
        format.html { redirect_to teams_url(tab: "commitments"), alert: 'Unprocessable entity'}
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @commitment.update_attribute(:closing_date, Date.today)
    byebug
    @commitment.update_attribute(:status, return_status(@commitment))
    redirect_to target_path(@commitment.target_id), notice: 'Commitment completed'
  end

  def show
    @task = Task.new
  end

  def edit
  end

  def update
    update_status(@commitment)
    @commitment.update(commitment_params)
    redirect_to teams_url(tab: "commitments")
  end

  def destroy
    @commitment.destroy
  end

  private
  def update_status

  end

  def set_commitment
    @commitment = Commitment.find(params[:id])
  end

  def commitment_params
    params.require(:commitment).permit(:action, :conditions_of_satisfaction, :start_date, :due_date, :target_id, :responsible_id , :deliverable, :critical, :renegotiation_date, documents: [])
  end
end
