import 'package:flutter/material.dart';
import 'package:pet_care_app/%20care_screen.dart';
import 'package:pet_care_app/feeding_screen.dart';
import 'package:pet_care_app/home_screen.dart';
import 'package:pet_care_app/setting_screen.dart';
import 'package:pet_care_app/reminder_screen.dart';
import 'package:pet_care_app/welcome_screen.dart';

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
        body: WelcomeScreen(),
      ),
      routes: {
        '/feeding': (context) {
          final Object? arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is int) {
            return FeedingScreen(petId: arguments);
          } else {
            throw ArgumentError('Invalid or missing petId argument for FeedingScreen');
          }
        },
        '/care': (context) {
          final Object? arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is int) {
            return CareScreen(petId: arguments);
          } else {
            throw ArgumentError('Invalid or missing petId argument for CareScreen');
          }
        },
        '/home': (context) {
          final Object? arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is int) {
            return HomeScreen(petId: arguments);
          } else {
            throw ArgumentError('Invalid or missing petId argument for HomeScreen');
          }
        },
        '/reminder': (context) {
          final Object? arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is int) {
            return ReminderScreen(petId: arguments); // Pass petId to ReminderScreen
          } else {
            throw ArgumentError('Invalid or missing petId argument for ReminderScreen');
          }
        },
        '/welcome': (context) => WelcomeScreen(),
        '/setting': (context) {
          final Object? arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is int) {
            return SettingScreen(petId: arguments);
          } else {
            throw ArgumentError('Invalid or missing petId argument for SettingScreen');
          }
        },
      },
    );
  }
}