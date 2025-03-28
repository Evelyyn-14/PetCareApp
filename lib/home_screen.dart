import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  final int petId;
  const HomeScreen({super.key, required this.petId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _todaysReminders = [];

  @override
  void initState() {
    super.initState();
    _loadTodaysReminders();
  }

  Future<void> _loadTodaysReminders() async {
    final reminders = await DatabaseHelper.getRemindersByPetId(widget.petId);
    final today = DateTime.now();
    setState(() {
      _todaysReminders = reminders.where((reminder) {
        final reminderDate = DateTime.parse(reminder['date']);
        return reminderDate.year == today.year &&
            reminderDate.month == today.month &&
            reminderDate.day == today.day;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 250,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 189, 118),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Welcome ProfileName!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Today\'s Reminders:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 390,
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromARGB(228, 252, 239, 165),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _todaysReminders.isEmpty
                    ? Center(
                        child: Text(
                          'No reminders for today.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _todaysReminders.length,
                        itemBuilder: (context, index) {
                          final reminder = _todaysReminders[index];
                          return ListTile(
                            title: Text(reminder['title']),
                            subtitle: Text(
                              '${reminder['description']} at ${reminder['time']}',
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Actions:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 390,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(228, 252, 239, 165),
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reminder', arguments: widget.petId);
                      },
                      icon: Icon(Icons.add_alert),
                      label: Text('Add Reminder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/feeding', arguments: widget.petId);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Feeding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Wrap(
                spacing: 10,
                children: List.generate(5, (index) {
                  final icons = [
                    Icons.pets,
                    Icons.lightbulb, 
                    Icons.house, 
                    Icons.calendar_month, 
                    Icons.settings,
                  ];
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                      Navigator.pushNamed(context, '/feeding', arguments: widget.petId);
                      }
                      if (index == 1) {
                        Navigator.pushNamed(context, '/care', arguments: widget.petId);
                      }
                      if (index == 3) {
                        Navigator.pushNamed(context, '/reminder', arguments: widget.petId);
                      }
                      if (index == 4) {
                        Navigator.pushNamed(context, '/setting', arguments: widget.petId);
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: index == 2 ? Colors.orange : Color.fromARGB(228, 252, 239, 165), // Highlight house icon
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          icons[index],
                          size: 50,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}