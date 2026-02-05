import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pankh/services/ser_userhive.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:pankh/screens/splash/splashscreen.dart';
import 'services/ser_birdhive.dart';


void main() async{
  // 1. Bridges the Flutter framework with the host platform (Android/iOS)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Starts Firebase using your generated AppIDs
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await SerUserHive.init();
  await SerBirdHive.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pankh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: SplashScreen(),
    );
  }
}
