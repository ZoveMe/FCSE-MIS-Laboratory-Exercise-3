import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/category_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'services/firebase_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const Color primaryColor = Color(0xFF3F5EFB);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  final List<Widget> screens = [
    const CategoryListScreen(),
    const FavoritesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _setupFirebaseNotifications();
  }

  Future<void> _setupFirebaseNotifications() async {
    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM TOKEN: $token");

    FirebaseMessaging.onMessage.listen((message) {
      if (!mounted) return;

      final title = message.notification?.title ?? "New Notification";
      final body = message.notification?.body ?? "";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$title\n$body")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MIS Meals",

      theme: ThemeData(
        primaryColor: MyApp.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: MyApp.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: MyApp.primaryColor,
          unselectedItemColor: Colors.grey,
        ),
      ),

      home: Scaffold(
        body: screens[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
