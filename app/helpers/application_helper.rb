module ApplicationHelper

  def user_avatar(user_id)
    user = User.find(user_id)
    if user.avatar.attached?
        user.avatar
    else
        'default.jpg'
    end
  end

end
