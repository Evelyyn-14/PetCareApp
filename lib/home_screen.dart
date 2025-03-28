import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class HomeScreen extends StatefulWidget {
  final int petId;
  const HomeScreen({Key? key, required this.petId}) : super(key: key);

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

  //loads reminders for the current date
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final backgroundColor =
            themeProvider.isDarkMode ? Colors.black : Colors.white;
        final headerColor = themeProvider.isDarkMode
            ? Colors.orange
            : const Color.fromARGB(255, 244, 189, 118);
        final cardColor = themeProvider.isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(228, 252, 239, 165);
        final textColor =
            themeProvider.isDarkMode ? Colors.white : Colors.black;
        final iconColor =
            themeProvider.isDarkMode ? Colors.orange : Colors.black;
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      width: 250,
                      height: 70,
                      decoration: BoxDecoration(
                        color: headerColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Today\'s Reminders:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 390,
                    height: 200,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _todaysReminders.isEmpty
                        ? Center(
                            child: Text(
                              'No reminders for today.',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white70
                                      : Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _todaysReminders.length,
                            itemBuilder: (context, index) {
                              final reminder = _todaysReminders[index];
                              return ListTile(
                                title: Text(
                                  reminder['title'],
                                  style: TextStyle(color: textColor),
                                ),
                                subtitle: Text(
                                  '${reminder['description']} at ${reminder['time']}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Quick Actions:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 390,
                    height: 200,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/reminder',
                                arguments: widget.petId);
                          },
                          icon: const Icon(Icons.add_alert),
                          label: const Text('Add Reminder'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.isDarkMode
                                ? Colors.orange
                                : Colors.orangeAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/feeding',
                                arguments: widget.petId);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Feeding'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.isDarkMode
                                ? Colors.orange
                                : Colors.orangeAccent,
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
                  padding: const EdgeInsets.only(bottom: 20),
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
                            Navigator.pushNamed(context, '/feeding',
                                arguments: widget.petId);
                          }
                          if (index == 1) {
                            Navigator.pushNamed(context, '/care',
                                arguments: widget.petId);
                          }
                          if (index == 3) {
                            Navigator.pushNamed(context, '/reminder',
                                arguments: widget.petId);
                          }
                          if (index == 4) {
                            Navigator.pushNamed(context, '/setting',
                                arguments: widget.petId);
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: index == 2
                                ? (themeProvider.isDarkMode
                                    ? Colors.orange
                                    : Colors.orange)
                                : (themeProvider.isDarkMode
                                    ? Colors.grey[850]
                                    : cardColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              icons[index],
                              size: 50,
                              color: index == 2 && themeProvider.isDarkMode
                                  ? Colors.black
                                  : iconColor,
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
      },
    );
  }
}
