import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();

  Future<void> markNotificationAsRead(String notificationId);

  Future<void> markAllNotificationsAsRead();

  Future<void> deleteNotification(String notificationId);
}
