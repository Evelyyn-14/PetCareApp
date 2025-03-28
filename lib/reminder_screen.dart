import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'theme_provider.dart';

class ReminderScreen extends StatefulWidget {
  final int petId;
  const ReminderScreen({Key? key, required this.petId}) : super(key: key);

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

  //load reminders from the database
  Future<void> _loadRemindersFromDatabase() async {
    final reminders = await DatabaseHelper.getRemindersByPetId(widget.petId);
    setState(() {
      _reminders = reminders;
    });
  }

  //add a new reminder
  void _addReminder() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Time'),
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
              child: const Text('Cancel'),
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  //edit an existing reminder
  void _editReminder(int index) {
    final reminder = _reminders[index];
    TextEditingController titleController =
        TextEditingController(text: reminder['title']);
    TextEditingController descriptionController =
        TextEditingController(text: reminder['description']);
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(reminder['time'].split(":")[0]),
      minute: int.parse(reminder['time'].split(":")[1].split(" ")[0]),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Time'),
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
              child: const Text('Cancel'),
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
                await DatabaseHelper.updateReminder(
                    updatedReminder.cast<String, Object>());
                Navigator.of(context).pop();
                _loadRemindersFromDatabase();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  //delete an existing reminder
  void _deleteReminder(int index) async {
    final reminderId = _reminders[index]['id'];
    if (reminderId != null) {
      await DatabaseHelper.deleteReminder(reminderId);
      _loadRemindersFromDatabase();
    }
  }

  //get reminders for the selected day
  List<Map<String, dynamic>> _getRemindersForDay(DateTime day) {
    return _reminders.where((reminder) {
      final reminderDate = DateTime.parse(reminder['date']);
      return reminderDate.day == day.day &&
          reminderDate.month == day.month &&
          reminderDate.year == day.year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final backgroundColor =
            themeProvider.isDarkMode ? Colors.black : Colors.white;
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.isDarkMode ? Colors.orange : Colors.orangeAccent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              onPressed: () => Navigator.pushNamed(
                context,
                '/home',
                arguments: widget.petId,
              ),
            ),
            title: const Text('Reminders'),
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
                    color: themeProvider.isDarkMode
                        ? Colors.orange
                        : Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.orange[700]
                        : Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _getRemindersForDay(_selectedDay ?? _focusedDay).length,
                  itemBuilder: (context, index) {
                    final reminder = _getRemindersForDay(_selectedDay ?? _focusedDay)[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(reminder['title'],
                            style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black)),
                        subtitle: Text(
                          '${reminder['description']} at ${reminder['time']}',
                          style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.black54),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editReminder(index);
                            } else if (value == 'delete') {
                              _deleteReminder(index);
                            }
                          },
                          itemBuilder: (context) => const [
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
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
