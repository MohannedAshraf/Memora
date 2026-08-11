import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationLoaded(this.notifications);

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  @override
  List<Object?> get props => [notifications];
}

class NotificationActionLoading extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationActionLoading(this.notifications);

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  @override
  List<Object?> get props => [notifications];
}

class NotificationFailure extends NotificationState {
  final String message;

  const NotificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
