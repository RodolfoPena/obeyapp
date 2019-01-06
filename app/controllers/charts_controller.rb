class ChartsController < ApplicationController
  include CommitmentsHelper

  def commitment_level
    render json: commitment_closed_in_term(current_user).group_by_year(:due_date, format: '%w').count
  end
end
