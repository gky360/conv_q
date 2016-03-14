module UsersHelper

  def user_to_link(user)
    link_to "@#{user.account}", user_path(account: user.account)
  end

end
