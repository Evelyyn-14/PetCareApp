import 'package:flutter/material.dart';
import 'package:pet_care_app/%20care_screen.dart';
import 'package:pet_care_app/feeding_screen.dart';
import 'package:pet_care_app/home_screen.dart';
import 'package:pet_care_app/setting_screen.dart';
import 'package:pet_care_app/reminder_screen.dart';
import 'package:pet_care_app/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Pet Care App',
          theme: ThemeData(
            brightness:
                themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          home: const WelcomeScreen(),
          routes: {
            '/welcome': (context) => const WelcomeScreen(), 
              //passes petId to its respective screen
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
                return ReminderScreen(petId: arguments);
              } else {
                throw ArgumentError('Invalid or missing petId argument for ReminderScreen');
              }
            },
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
      },
    );
  }
}
