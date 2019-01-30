class ChartsController < ApplicationController
  include CommitmentsHelper

  def planning_level
    render json: planned_commitments_chart_by(current_user, 7).group_by_week(:closing_date, week_start: :mon).count
  end

  def commitment_level
    sum = 0
    x = (current_user.owner_commitments.where(status: [4,5,6]).group_by_week(:closing_date, week_start: :mon).count).map{|k,v| [k, (sum += v)]}.to_h
    y = (current_user.owner_commitments.where(status: 5).group_by_week(:closing_date, week_start: :mon).count).map{|k,v| [k, (sum += v)]}.to_h
    z = y.map{|k,v| [k,((x[k]/v.to_f)*100).to_i]}.to_h
    render json: z
  end

  def commitment_status
    render json: current_user.owner_commitments.group(:status, week_start: :mon).count
  end

end
