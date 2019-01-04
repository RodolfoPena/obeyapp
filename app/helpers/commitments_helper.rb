module CommitmentsHelper

  def total_deliverables(target)
    target.commitments.where(deliverable:true).count
  end

  def total_closed_deliverables(target)
    target.commitments.where.not(deliverable:false, closing_date: nil).count
  end

  def target_progress(target)
    if total_deliverables(target) != 0
      (total_closed_deliverables(target).to_f/total_deliverables(target).to_f)*100
    else
      0.00
    end
  end

  def bg_targets(target)
    if target_progress(target) < 30
      "bg-danger"
    elsif target_progress(target) >= 30 && target_progress(target) < 80
      "bg-warning"
    else
      "bg-success"
    end
  end

  def closing_after_complete(commitment)
    if commitment.renegotiation_date.nil?
      if commitment.closing_date <= commitment.due_date
        commitment.update_attribute(:closed_in_term, true)
      else
        commitment.update_attribute(:closed_in_term, false)
      end
    else
      if commitment.closing_date <= commitment.due_date || commitment.closing_date <= commitment.renegotiation_date
        commitment.update_attribute(:closed_in_term, true)
      else
        commitment.update_attribute(:closed_in_term, false)
      end
    end
  end

  def commitment_closed_in_term?(commitment)
    due_date = commitment.due_date
    renegotiation_date = commitment.renegotiation_date
    closing_date = commitment.closing_date
    if closing_date > due_date || closing_date > renegotiation_date
      commitment.closed_in_term = false
    else
      commitment.closed_in_term = true
    end
  end

  def planning_days(commitment)
    start_date = commitment.start_date
    due_date = commitment.due_date
    commitment.planning_days = due_date - start_date
  end


  def owner_commitment(commitment)
    User.find(commitment).first_name
  end

  def user_id_for_commitment(commitment)
    User.find(commitment.to_i).id
  end


  def backlog_commitments(target)
      target.commitments.where(due_date: nil)
  end

  def waiting_commitments(target)
    target.commitments.where.not(due_date: nil, closing_date: "?")
  end

  def this_week_commitments(target)
      target.commitments.where(due_date: 1.week.ago..Date.today, closing_date: nil)
  end

  def today_commitments(target)
      target.commitments.where(due_date: Date.today, closing_date: nil)
  end

  def done_commitments(target)
      target.commitments.where.not(closing_date: nil)
  end

end
