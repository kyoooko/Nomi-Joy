module Public::NotificationsHelper
  def unchecked_notifications
    current_user.passive_notifications.where(checked: false)
  end
end
