import 'package:memora/features/notification/domain/repo/notification_repository.dart';


class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String notificationId) {
    return repository.markNotificationAsRead(notificationId);
  }
}
