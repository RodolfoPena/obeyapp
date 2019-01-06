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

  def level_of_commitment(user)
    if user.owner_commitments.count.to_f == 0
      return 0
    else
    (((user.owner_commitments.where(closed_in_term: true)).count.to_f)/((user.owner_commitments).count.to_f)*100).round(0)
    end
  end

  def level_of_planification(user)
    if user.owner_commitments.count.to_f == 0
      return 0
    else
      (((user.owner_commitments.where('(due_date - start_date > 7)').count.to_f)/((user.owner_commitments).count.to_f))*100).round(0)
    end
  end

  def level_of_fullfillment(user)
    (((user.owner_commitments.where('(due_date - start_date > 7)').count.to_f)/((user.owner_commitments).count.to_f))*100).round(0)
  end

  def commitment_closed_in_term(user)
    user.owner_commitments.where(closed_in_term: true)
  end







  # Specials setters
  def set_status(commitment)
    if backlog?(commitment) == true
      commitment.update_attribute(:status, 0)
    elsif waiting?(commitment) == true
      commitment.update_attribute(:status, 1)
    elsif this_week?(commitment) == true
      commitment.update_attribute(:status, 2)
    elsif today?(commitment) == true
      commitment.update_attribute(:status, 3)
    else
      commitment.update_attribute(:status, 4)
    end
  end

  def set_status_create(commitment)
    case commitment
    when backlog?(commitment) == true
      commitment.status = 0
    when waiting?(commitment) == true
      commitment.status = 1
    when this_week?(commitment) == true
      commitment.status = 2
    when today?(commitment) == true
      commitment.status = 3
    end
  end

  def backlog?(commitment)
    commitment.due_date.nil? ? true : false
  end

  def this_week?(commitment)
    if commitment.renegotiation_date.nil?
      (commitment.closing_date.nil? && ((commitment.due_date >= Date.today.at_beginning_of_week && commitment.due_date <= (Date.today.at_beginning_of_week + 6.days)))) ? true : false
    else
      true if (commitment.closing_date.nil? && ((commitment.renegotiation_date >= Date.today.at_beginning_of_week && commitment.renegotiation_date <= (Date.today.at_beginning_of_week + 6.days))))
    end
  end

  def waiting?(commitment)
    true if commitment.due_date.nil? == false && this_week?(commitment) == false
  end

  def today?(commitment)
    (commitment.due_date == Date.today || commitment.renegotiation_date == Date.today) ? true : false
  end

  def done?(commitment)
  commitment.closing_date.nil? == false ? true : false
  end

end
