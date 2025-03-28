import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget{
  final int petId;
  const ReminderScreen({super.key, required this.petId});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home',
          arguments: widget.petId,
          ),
        )
      ),
    );
  }
}