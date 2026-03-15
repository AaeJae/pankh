import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pankh/constants/appTokens.dart';

import 'firebase_options.dart';
// Custom packages
import 'services/ser_birdhive.dart';
import 'services/ser_userhive.dart';
import 'package:pankh/screens/splash/splashscreen.dart';

void main() async {
  // 1. Bridges Flutter with the platform
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); //
  // 2. Start Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Initialize Hive Services
  // We move Hive.initFlutter() inside these inits for cleaner architecture
  await SerUserHive.init();
  await SerBirdHive.init();
  await Hive.openBox('settings');

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pankh',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green, // Fits the birding theme!
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}