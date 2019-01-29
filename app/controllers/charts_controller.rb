class ChartsController < ApplicationController
  include CommitmentsHelper

  def planning_level
    render json: planned_commitments_chart_by(current_user, 7).group_by_week(:closing_date, week_start: :mon).count
  end

  def commitment_level
    sum = []
    array_of_commitments = current_user.owner_commitments.where.not(closing_date: nil).map{|x| sum += x}
    array_of_commitments_by_week = array_of_commitments.group_by_week(:closing_date, week_start: :mon)

    # cumulative_of_commitments = (array_of_commitments.group_by_week(:closing_date, week_start: :mon)).count.map{|x| sum += x}

    render json: array_of_commitments_by_week.count
  end

  def commitment_status
    render json: current_user.owner_commitments.group(:status, week_start: :mon).count
  end

end
