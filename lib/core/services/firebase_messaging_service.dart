import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  FirebaseMessagingService();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Firebase Messaging on Web needs additional configuration
    // such as a VAPID key, so skip it for now.
    if (kIsWeb) {
      log('Firebase Messaging skipped on Web');
      return;
    }

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    log('Notification permission: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();

    log('FCM Token: $token');

    _messaging.onTokenRefresh.listen((newToken) {
      log('FCM Token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground notification received');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
      log('Data: ${message.data}');
    });
  }
}
