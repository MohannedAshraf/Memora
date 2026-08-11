import 'package:memora/features/notification/domain/repo/notification_repository.dart';

import '../entities/notification_entity.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() {
    return repository.getNotifications();
  }
}
