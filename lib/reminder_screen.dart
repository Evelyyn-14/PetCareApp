import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';

class ReminderScreen extends StatefulWidget {
  final int petId;
  const ReminderScreen({super.key, required this.petId});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadRemindersFromDatabase();
  }

  //gets the reminders from the database
  Future<void> _loadRemindersFromDatabase() async {
    final reminders = await DatabaseHelper.getRemindersByPetId(widget.petId);
    setState(() {
      _reminders = reminders;
    });
  }

  //adds a reminder to the database
  void _addReminder() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Time'),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                  text: selectedTime.format(context),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newReminder = {
                  'pet_id': widget.petId,
                  'date': _selectedDay != null
                      ? _selectedDay.toString()
                      : _focusedDay.toString(),
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'time': selectedTime.format(context),
                };
                await DatabaseHelper.insertReminder(newReminder);
                Navigator.of(context).pop();
                _loadRemindersFromDatabase();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  //edits a reminder in the database
  void _editReminder(int index) {
    final reminder = _reminders[index];
    TextEditingController titleController = TextEditingController(text: reminder['title']);
    TextEditingController descriptionController = TextEditingController(text: reminder['description']);
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(reminder['time'].split(":")[0]),
      minute: int.parse(reminder['time'].split(":")[1].split(" ")[0]),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Time'),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                  text: selectedTime.format(context),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedReminder = {
                  'id': reminder['id'],
                  'pet_id': widget.petId,
                  'date': reminder['date'],
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'time': selectedTime.format(context),
                };
                await DatabaseHelper.updateReminder(updatedReminder.cast<String, Object>());
                Navigator.of(context).pop();
                _loadRemindersFromDatabase(); 
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  //deletes a reminder from the database
  void _deleteReminder(int index) async {
    final reminderId = _reminders[index]['id'];
    if (reminderId != null) {
      await DatabaseHelper.deleteReminder(reminderId); 
      _loadRemindersFromDatabase();
    }
  }

  List<Map<String, dynamic>> _getRemindersForDay(DateTime day) {
    return _reminders.where((reminder) {
      return DateTime.parse(reminder['date']).day == day.day &&
          DateTime.parse(reminder['date']).month == day.month &&
          DateTime.parse(reminder['date']).year == day.year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(
            context,
            '/home',
            arguments: widget.petId,
          ),
        ),
        title: Text('Reminders'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _getRemindersForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                final reminder = _getRemindersForDay(_selectedDay ?? _focusedDay)[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(reminder['title']),
                    subtitle: Text('${reminder['description']} at ${reminder['time']}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editReminder(index);
                        } else if (value == 'delete') {
                          _deleteReminder(index);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}