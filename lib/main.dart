import 'package:assignment1/services/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/services/DatabaseHelper.dart';

import 'AuthenticationScreen.dart';
import 'LoginScreen.dart';
import 'SignupScreen.dart';
import 'homeScreen.dart';
import 'profileScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Signup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticationScreen(),
        '/home': (context) => const homeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
