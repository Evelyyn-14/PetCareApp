import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  
  void _catProfileDialog() {
    _nameController.clear();
    _ageController.clear();
    _genderController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          title: Text('Enter Cat Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cat Name')
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Cat Age')
              ),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Cat Gender')
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')
            ),
            TextButton (
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Save')
            )
          ],
        );
      },
    );
  }

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
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _catProfileDialog(),
        icon: Icon(Icons.pets),
        label: const Text("Create Cat Profile")
      )
    );
  }
}