module TargetsHelper
  def find_user(user_id)
    User.find(user_id)
  end

  def targets_where_current_user_is_responsible(user)
    Target.all.where(responsible_id: user.id)
  end

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
  
end
