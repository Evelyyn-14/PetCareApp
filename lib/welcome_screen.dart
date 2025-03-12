import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 100),
          width: 350,
          height: 130,
          decoration: BoxDecoration(  
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'Welcome to CatCare!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )
              )
          )
        )
      )
    );
  }
}