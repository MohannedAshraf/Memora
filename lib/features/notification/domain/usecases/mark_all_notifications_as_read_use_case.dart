import 'package:memora/features/notification/domain/repo/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<void> call() {
    return repository.markAllNotificationsAsRead();
  }
}
