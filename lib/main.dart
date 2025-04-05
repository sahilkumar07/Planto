import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planto/login_screen.dart';
import 'package:planto/signup_screen.dart';
const Color darkFontGrey = Color.fromRGBO(62, 68, 71, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC2J1RCpA9Z8sEaBNgGw4TQibcHmvXd0VA",
        authDomain: "planto-6aafe.firebasestorage.app",
        projectId: "planto-6aafe",
        appId: "1:136991639825:android:db033d6adb1a7ba549e4b0",
        messagingSenderId: "136991639825",
        storageBucket: "planto-6aafe.appspot.com",
      ),
    );
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Planto",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          backgroundColor: Colors.transparent,
        ),
        fontFamily: "sans_regular",
      ),
      home: LoginScreen(),
    );
  }
}
