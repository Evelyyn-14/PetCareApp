import 'package:flutter/material.dart';
import 'package:pet_care_app/feeding_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedingScreen(),
    );
  }
}