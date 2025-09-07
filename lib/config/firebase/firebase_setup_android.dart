import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseSetup() async {
  try {
    await Firebase.initializeApp();
    print("✅ Firebase initialized successfully");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }
  await NotificationService().init();
}

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permissions (iOS)
    await _fcm.requestPermission();

    // Subscribe to topic
    await _fcm.subscribeToTopic("general");

    // Get token
    String? token = await _fcm.getToken();
    print("FCM Token: $token");

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Foreground message: ${message.notification?.title} / ${message.notification?.body}");
    });

    // When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.data}");
    });

    // Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
