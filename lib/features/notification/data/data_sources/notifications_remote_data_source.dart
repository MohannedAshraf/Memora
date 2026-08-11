import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();

  Future<void> markNotificationAsRead(String notificationId);

  Future<void> markAllNotificationsAsRead();

  Future<void> deleteNotification(String notificationId);
}
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final SupabaseClient client;

  NotificationsRemoteDataSourceImpl(this.client);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final data = await client
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (data as List)
        .map(
          (json) => NotificationModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', user.id);
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', user.id)
        .eq('is_read', false);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    await client
        .from('notifications')
        .delete()
        .eq('id', notificationId)
        .eq('user_id', user.id);
  }
}
