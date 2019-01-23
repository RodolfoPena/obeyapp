class ChartsController < ApplicationController
  include CommitmentsHelper

  def planning_level
    render json: planned_commitments_chart_by(current_user, 7).group_by_week(:closing_date, week_start: :mon).count
  end

  def commitment_level
    render json: array_of_commitments_by(current_user, 6).group_by_week(:closing_date, week_start: :mon).count
  end

  def commitment_status
    render json: current_user.owner_commitments.group(:status, week_start: :mon).count
  end

end
