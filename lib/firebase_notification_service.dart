import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:shams/app/config/constants.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications and setup FCM
  Future<void> initializeNotifications() async {
    // Request notification permissions (iOS + Android safe)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔐 Notification permission granted');

      // Get APNs Token for iOS
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      print('📱 APNs Token: $apnsToken');

      // Get FCM Token
      //Constants.fcmToken = (await _firebaseMessaging.getToken()) ?? "";
      //print("🔥 Initial FCM Token: ${Constants.fcmToken}");

      // Subscribe to topic at startup
      await subscribeToTopic("khalesi_ios");

      // Listen for token refresh → re-subscribe to topic
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 New FCM Token: $newToken');
        // Constants.fcmToken = newToken;
        subscribeToTopic("khalesi_ios");
      });

      // Configure local notifications
      await _configureLocalNotifications();

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(handleFirebaseBackgroundMessage);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Message in foreground: ${message.notification?.title}");
        _showLocalNotification(message);
      });
    } else {
      print('❌ Notification permission not granted');
    }
  }

  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print("✅ Subscribed to topic: $topic");
    } catch (e) {
      print("❌ Failed to subscribe to topic: $e");
    }
  }

  // Configure local notifications
  Future<void> _configureLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔔 Notification tapped: ${response.payload}");
      },
    );
  }

  // Display local notification for foreground message
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default',
      channelDescription: 'Default notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformDetails,
      );
    }
  }
}

// Background message handler
Future<void> handleFirebaseBackgroundMessage(RemoteMessage message) async {
  print("📬 Handling a background message: ${message.messageId}");
}
