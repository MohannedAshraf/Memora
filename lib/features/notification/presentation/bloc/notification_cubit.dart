import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memora/features/notification/domain/usecases/delete_notification_use_case.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/mark_all_notifications_as_read_use_case.dart';
import '../../domain/usecases/mark_notification_as_read_use_case.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.deleteNotificationUseCase,
  }) : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());

    try {
      final notifications = await getNotificationsUseCase();

      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final currentState = state;

    if (currentState is! NotificationLoaded) {
      return;
    }

    try {
      await markNotificationAsReadUseCase(notificationId);

      final updatedNotifications = currentState.notifications.map((
        notification,
      ) {
        if (notification.id == notificationId) {
          return NotificationEntity(
            id: notification.id,
            userId: notification.userId,
            actorId: notification.actorId,
            type: notification.type,
            title: notification.title,
            body: notification.body,
            albumId: notification.albumId,
            metadata: notification.metadata,
            isRead: true,
            createdAt: notification.createdAt,
          );
        }

        return notification;
      }).toList();

      emit(NotificationLoaded(updatedNotifications));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;

    if (currentState is! NotificationLoaded) {
      return;
    }

    try {
      await markAllNotificationsAsReadUseCase();

      final updatedNotifications = currentState.notifications.map((
        notification,
      ) {
        return NotificationEntity(
          id: notification.id,
          userId: notification.userId,
          actorId: notification.actorId,
          type: notification.type,
          title: notification.title,
          body: notification.body,
          albumId: notification.albumId,
          metadata: notification.metadata,
          isRead: true,
          createdAt: notification.createdAt,
        );
      }).toList();

      emit(NotificationLoaded(updatedNotifications));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final currentState = state;

    if (currentState is! NotificationLoaded) {
      return;
    }

    try {
      await deleteNotificationUseCase(notificationId);

      final updatedNotifications = currentState.notifications
          .where((notification) => notification.id != notificationId)
          .toList();

      emit(NotificationLoaded(updatedNotifications));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }
}
