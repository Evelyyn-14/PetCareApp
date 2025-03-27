import 'package:flutter/material.dart';
import 'package:pet_care_app/%20care_screen.dart';
import 'package:pet_care_app/feeding_screen.dart';
import 'package:pet_care_app/home_screen.dart';
import 'package:pet_care_app/welcome_screen.dart';
import 'package:pet_care_app/setting_screen.dart';
import 'package:pet_care_app/database_helper.dart';
import 'package:pet_care_app/reminder_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pet Care App'),
        ),
        body: HomeScreen()
        // body: WelcomeScreen(),
      ),
      routes: {
        '/feeding': (context) => FeedingScreen(),
        '/setting': (context) => SettingScreen(),
        '/care': (context) => CareScreen(),
        '/home': (context) => HomeScreen(),
        '/reminder': (context) => ReminderScreen(),

      
      },
    );
  }
}