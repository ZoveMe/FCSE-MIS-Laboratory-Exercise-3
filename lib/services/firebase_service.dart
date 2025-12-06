// lib/services/firebase_service.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// OPTIONAL: ако сакаш да обработуваш нотификации во background
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // НЕ викаме Firebase.initializeApp() овде, за да не влезе во чудни лупови
  debugPrint('🔕 BG message: ${message.notification?.title}');
}

class FirebaseService {
  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;

    // Background handler – се регистрира еднаш, пред runApp (во main)
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // Бараме дозвола (Android 13+ и iOS)
    await messaging.requestPermission();

    // Земаме FCM токен
    final token = await messaging.getToken();
    debugPrint('🔥 FCM TOKEN: $token');

    // Се пријавуваме на topic
    await messaging.subscribeToTopic('daily_recipe');
  }
}
