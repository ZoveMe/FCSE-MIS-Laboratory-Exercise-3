
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> firebaseBackgroundHandler(RemoteMessage message) async {

  debugPrint('🔕 BG message: ${message.notification?.title}');
}

class FirebaseService {
  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;


    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);


    await messaging.requestPermission();


    final token = await messaging.getToken();
    debugPrint('🔥 FCM TOKEN: $token');


    await messaging.subscribeToTopic('daily_recipe');
  }
}
