module ApplicationHelper

  def user_avatar(user_id)
    user = User.find(user_id)
    if user.avatar.attached?
        user.avatar
    else
        'default.jpg'
    end
  end

  def user_name(user_id)
    user = User.find(user_id)
    user.first_name
  end

end
