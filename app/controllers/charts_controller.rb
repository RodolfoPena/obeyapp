class ChartsController < ApplicationController
  include CommitmentsHelper

  def commitment_level
    render json: commitment_closed_in_term(current_user).group_by_week(:closing_date, range: Date.today.beginning_of_year..Date.today.end_of_year).count
  end
end
