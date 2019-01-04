module TargetsHelper
  def find_user(user_id)
    User.find(user_id)
  end

  def targets_where_current_user_is_responsible(user)
    Target.all.where(responsible_id: user.id)
  end
end
