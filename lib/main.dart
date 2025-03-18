import 'package:flutter/material.dart';
import 'setting_screen.dart';
import 'welcome_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingScreen()
      home: WelcomeScreen(),
    );
  }
}