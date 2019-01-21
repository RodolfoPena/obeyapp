module CommitmentsHelper

  def commitments_by(object, status)
    if object.is_a?(User)
      object.owner_commitments.where(status: status).count
    elsif object.is_a?(Team)
      array = []
      object.targets.each do |target|
        array << target.commitments.where(status: status).count
      end
      array.inject(0){|sum, x| sum + x }/array.length
    elsif object.is_a?(Target)
      object.commitments.where(status: status).count
    end
  end

  def commitments_average_by(object, status)
    array = []
    object.each do |element|
      array << commitments_by(element, status)
    end
      (array.inject(0){|sum, x| sum + x }/array.length)
  end

  def planned_commitments_chart_by(object, acceptable_planning)
    if object.is_a?(User)
      object.owner_commitments.where('(due_date - start_date > ? )', acceptable_planning)
    elsif object.is_a?(Team)
      array = []
      object.targets.each do |target|
        array << target.commitments.where('(due_date - start_date > ? )', acceptable_planning)
      end
      array
    elsif object.is_a?(Target)
      object.commitments.where('(due_date - start_date > ? )', acceptable_planning)
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

  def owner_commitment(commitment)
    User.find(commitment).first_name
  end

  def user_id_for_commitment(commitment)
    User.find(commitment.to_i).id
  end


  def backlog_commitments(target)
      target.commitments.where(status: 0)
  end

  def waiting_commitments(target)
    target.commitments.where(status: 1)
  end

  def this_week_commitments(target)
      target.commitments.where(status: 2)
  end

  def today_commitments(target)
      target.commitments.where(status: 3)
  end

  def done_commitments(target)
      target.commitments.where(status: 4)
  end


  def commitments_closed_in_term(user)
    user.owner_commitments.where(closed_in_term: true)
  end

  # Obeya Skills

  def level_of_commitment(user)
    if user.owner_commitments.count.to_f == 0
      return 0
    else
    (((user.owner_commitments.where(closed_in_term: true)).count.to_f)/((user.owner_commitments.where.not(closing_date: nil)).count.to_f)*100).round(0)
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
    (((user.owner_commitments.where.not(closing_date: nil).count.to_f)/((user.owner_commitments).count.to_f))*100).round(0)
  end

  # Specials setters
  def self.set_status(commitment)
    if backlog?(commitment)
      commitment.status = 0
    elsif waiting?(commitment)
      commitment.status = 1
    elsif this_week?(commitment)
      commitment.status = 2
    elsif today?(commitment)
      commitment.status = 3
    else
      commitment.status = 4
    end
  end

  def self.backlog?(commitment)
    commitment.due_date.nil? ? true : false
  end

  def self.this_week?(commitment)
    if commitment.renegotiation_date.nil?
      true if (commitment.closing_date.nil? && ((commitment.due_date >= Date.today.at_beginning_of_week && commitment.due_date <= (Date.today.at_beginning_of_week + 6.days)))) ? true : false
    else
      true if (commitment.closing_date.nil? && ((commitment.renegotiation_date >= Date.today.at_beginning_of_week && commitment.renegotiation_date <= (Date.today.at_beginning_of_week + 6.days))))
    end
    false
  end

  def self.waiting?(commitment)
    true if commitment.due_date.nil? == false && this_week?(commitment) == false
  end

  def self.today?(commitment)
    (commitment.due_date == Date.today || commitment.renegotiation_date == Date.today) ? true : false
  end

  def self.done?(commitment)
    commitment.closing_date.nil? == false ? true : false
  end

end
