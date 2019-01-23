module CommitmentsHelper

  # expected output: number of commitments by object(user, target or team)
  def commitments_by(object, status)
    commitments = []
    if object.is_a?(User)
      commitments = object.owner_commitments.where(status: status).count
    elsif object.is_a?(Target)
      commitments = object.commitments.where(status: status).count
    elsif object.is_a?(Team)
      array = []
      object.targets.each do |target|
        array << target.commitments.where(status: status).count
      end
      commitments = array.inject(0){|sum, x| sum + x }.to_f/array.length if array.length.zero? == false
    end
    commitments != 0 ? commitments: 0
  end

  # expected output: average of commitments by teams
  def average_of_commitments_by_team(teams, status)
    array = []
    teams.each do |team|
      team.targets.each do |target|
        array << target.commitments.where(status: status).count
      end
    end
    commitments = array.inject(0){|sum, x| sum + x }.to_f/array.length if array.length.zero? == false
  end

  # expected output: array of commitments by object(user, target or team)
  def array_of_commitments_by(object, status)
    commitments = []
    if object.is_a?(User)
      commitments = object.owner_commitments.where(status: status)
    elsif object.is_a?(Target)
      commitments = object.commitments.where(status: status)
    elsif object.is_a?(Team)
      array = []
      object.targets.each do |target|
        array << target.commitments.where(status: status)
      end
      commitments = array
    end
    return commitments
  end

  def deviation_percentage(number_one, number_two)
    number_one = number_one.to_f
    number_two = number_two.to_f
    number_one >= 0 ? ((number_one/(number_one - number_two))*100).round(1) : 0
  end

  def deviation_in_numbers(number_one, number_two)
    number_one = number_one.to_f
    number_two = number_two.to_f
    (number_one - number_two)
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


  def self.closing_after_complete(commitment)
    closed_after_deadline(commitment) ? true : false
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

  def expired_commitments(target)
      target.commitments.where(status: 4)
  end

  def closed_before_deadline_commitments(target)
      target.commitments.where(status: 5)
  end

  def closed_after_deadline_commitments(target)
      target.commitments.where(status: 6)
  end


  def commitments_closed_in_term(user)
    user.owner_commitments.where(closed_in_term: true)
  end

  # Obeya Skills

  def level_of_commitment(user)
    user.owner_commitments.count == 0 ? 0 : ((user.owner_commitments.where(closed_in_term: true).count.to_f/ user.owner_commitments.count)*100).round(2)
  end

  def level_of_planification(user)
    user.owner_commitments.count.to_f == 0 ? 0 : (((user.owner_commitments.where('(due_date - start_date > 7)').count.to_f)/((user.owner_commitments).count.to_f))*100).round(0)
    end
  end

  def level_of_fullfillment(user)
    if user.owner_commitments.count.to_f == 0
      return 0
    else
    (((user.owner_commitments.where.not(closing_date: nil).count.to_f)/((user.owner_commitments).count.to_f))*100).round(0)
  end
  end

  # Specials setters
  def set_status(commitment)
    if backlog?(commitment)
      commitment.status = 0
    elsif waiting?(commitment)
      commitment.status = 1
    elsif this_week?(commitment)
      commitment.status = 2
    elsif today?(commitment)
      commitment.status = 3
    elsif expired?(commitment)
      commitment.status = 4
    elsif closed_before_deadline?(commitment)
      commitment.status = 5
    elsif closed_after_deadline(commitment)
      commitment.status = 6
    else
      commitment.status = nil
    end
  end

  def return_status(commitment)
    if backlog?(commitment)
      0
    elsif waiting?(commitment)
      1
    elsif this_week?(commitment)
      2
    elsif today?(commitment)
      3
    elsif expired?(commitment)
      4
    elsif closed_before_deadline?(commitment)
      5
    elsif closed_after_deadline?(commitment)
      6
    end
  end

  def renegotiated?(commitment)
    commitment.renegotiation_date.nil? ? false : true
  end

  def closed?(commitment)
    commitment.closing_date.nil? ? false : true
  end

  def backlog?(commitment)
    (commitment.due_date.nil? || commitment.renegotiation_date.nil?) && (closed?(commitment) == false)
  end

  def waiting?(commitment)
    if closed?(commitment)
      false
    else
      if today?(commitment)
        false
      else
        if renegotiated?(commitment)
          (this_week?(commitment) == false) ? true : false
        else
          (commitment.due_date.nil? == false && this_week?(commitment) == false) ? true : false
        end
      end
    end
  end

  def this_week?(commitment)
    beginning_of_week = Date.today.at_beginning_of_week
    end_of_week = Date.today.at_end_of_week
    if closed?(commitment)
      false
    else
      if today?(commitment)
        false
      else
        if renegotiated?(commitment)
          (commitment.renegotiation_date >= beginning_of_week && commitment.renegotiation_date <= end_of_week) ? true : false
        else
          (commitment.due_date >= beginning_of_week && commitment.due_date <= end_of_week) ? true : false
        end
      end
    end
  end

  def today?(commitment)
    today = Date.today
    (commitment.due_date == today|| commitment.renegotiation_date == today) ? true : false
  end

  def expired?(commitment)
    today = Date.today
    if closed?(commitment)
      false
    else
      if renegotiated?(commitment)
        (commitment.renegotiation_date > today) ? true : false
      else
        (commitment.due_date > today) ? true : false
      end
    end
  end

  def closed_after_deadline?(commitment)
    if closed?(commitment)
      if renegotiated?(commitment)
        (commitment.closing_date > commitment.renegotiation_date) ? true : false
      else
        (commitment.closing_date > commitment.due_date) ? true : false
      end
    else
      false
    end
  end

  def closed_before_deadline?(commitment)
    if closed?(commitment)
      return true if (commitment.renegotiation_date.nil? || commitment.due_date.nil?)
      if renegotiated?(commitment)
        (commitment.closing_date <= commitment.renegotiation_date) ? true : false
      else
        (commitment.closing_date <= commitment.due_date) ? true : false
      end
    else
      false
    end
  end
