import 'package:memora/features/notification/data/data_sources/notifications_remote_data_source.dart';
import 'package:memora/features/notification/domain/repo/notification_repository.dart';

import '../../domain/entities/notification_entity.dart';


class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() {
    return remoteDataSource.getNotifications();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) {
    return remoteDataSource.markNotificationAsRead(notificationId);
  }

  @override
  Future<void> markAllNotificationsAsRead() {
    return remoteDataSource.markAllNotificationsAsRead();
  }

  @override
  Future<void> deleteNotification(String notificationId) {
    return remoteDataSource.deleteNotification(notificationId);
  }
}
