import 'package:flutter/material.dart';
import 'package:pet_care_app/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _nightMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _nightMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/home')
            ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 189, 118),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.pets, size: 100),
                ),
              ),
              SizedBox(height: 20),
              Text('Placeholder', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Color.fromARGB(228, 252, 239, 165),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _nightMode = !_nightMode;
                        });
                      },
                      icon: Icon(Icons.nightlight_round),
                      label: Text('Toggle Light/Night Mode'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/welcome');
                      },
                      icon: Icon(Icons.switch_account),
                      label: Text('Switch Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
