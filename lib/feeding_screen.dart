import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class FeedingScreen extends StatefulWidget {
  final int petId;
  const FeedingScreen({Key? key, required this.petId}) : super(key: key);

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  int? _selectedPetId;

  List<Map<String, String>> _feedings = [];
  List<Map<String, String>> _filteredFeedings = [];

  List<String> weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  String _selectedType = 'Food';
  String _selectedUnit = 'Grams';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _selectedPetId = widget.petId;
    _loadFeedings();
  }

  //gets the index of the day of the week
  int _getDayIndex(DateTime date) => date.weekday - 1;

  //filters the feedings by the selected day
  void _filterFeedingsByDay(int dayIndex) {
    setState(() {
      _filteredFeedings = _feedings.where((feeding) {
        DateTime feedingDate =
            DateFormat('MM/dd/yyyy').parse(feeding['date']!);
        return _getDayIndex(feedingDate) == dayIndex;
      }).toList();
    });
  }

  //loads the feedings from the database
  Future<void> _loadFeedings() async {
    if (_selectedPetId != null) {
      final feedings = await DatabaseHelper.getFeedingsByPetId(_selectedPetId!);
      setState(() {
        _feedings = feedings.map((feeding) => {
              'id': feeding['id'].toString(),
              'food': feeding['food'] as String,
              'type': feeding['type'] as String,
              'amount': feeding['amount'].toString(),
              'unit': feeding['unit'] as String,
              'date': feeding['date'] as String,
              'time': feeding['time'] as String,
            }).toList().cast<Map<String, String>>();
      });
    }
  }

  //adds a new feeding log
  Future<void> _addFeeding() async {
    TextEditingController foodController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    _selectedType = 'Food';
    _selectedUnit = 'Grams';
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add New Feeding Log',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: foodController,
                  decoration: const InputDecoration(labelText: 'Food'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButton<String>(
                        value: _selectedType,
                        items: const [
                          DropdownMenuItem(
                              value: 'Food', child: Text('Food')),
                          DropdownMenuItem(
                              value: 'Water', child: Text('Water')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                        hint: const Text('Select Type'),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return DropdownButton<String>(
                          value: _selectedUnit,
                          items: const [
                            DropdownMenuItem(
                                value: 'Grams', child: Text('Grams')),
                            DropdownMenuItem(
                                value: 'Milliliters',
                                child: Text('Milliliters')),
                            DropdownMenuItem(
                                value: 'Ounces', child: Text('Ounces')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value!;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('MM/dd/yyyy').format(_selectedDate),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Time'),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedTime.format(context),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.insertFeedingLog({
                  'pet_id': _selectedPetId!,
                  'food': foodController.text,
                  'type': _selectedType,
                  'amount': double.parse(amountController.text),
                  'unit': _selectedUnit,
                  'date': DateFormat('MM/dd/yyyy').format(_selectedDate),
                  'time': _selectedTime.format(context),
                });
                Navigator.of(context).pop();
                _loadFeedings();
              },
              child: const Text('Add Log'),
            ),
          ],
        );
      },
    );
  }

  //edits an existing feeding log
  Future<void> _editFeeding(int index) async {
    Map<String, String> feeding = _feedings[index];
    TextEditingController foodController =
        TextEditingController(text: feeding['food']);
    TextEditingController amountController =
        TextEditingController(text: feeding['amount']);
    String selectedType = feeding['type']!;
    String selectedUnit = feeding['unit']!;
    DateTime selectedDate =
        DateFormat('MM/dd/yyyy').parse(feeding['date']!);
    List<String> timeParts = feeding['time']!.split(RegExp('[: ]'));
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Feeding Log'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: foodController,
                      decoration: const InputDecoration(labelText: 'Food'),
                    ),
                    DropdownButton<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                            value: 'Food', child: Text('Food')),
                        DropdownMenuItem(
                            value: 'Water', child: Text('Water')),
                        DropdownMenuItem(
                            value: 'Medicine', child: Text('Medicine')),
                        DropdownMenuItem(
                            value: 'Treat', child: Text('Treat')),
                        DropdownMenuItem(
                            value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                      hint: const Text('Select Type'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            decoration:
                                const InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedUnit,
                          items: const [
                            DropdownMenuItem(
                                value: 'Grams', child: Text('Grams')),
                            DropdownMenuItem(
                                value: 'Milliliters',
                                child: Text('Milliliters')),
                            DropdownMenuItem(
                                value: 'Ounces', child: Text('Ounces')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedUnit = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('MM/dd/yyyy').format(selectedDate),
                      ),
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
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Map<String, Object> updatedLog = {
                  'id': int.parse(feeding['id']!),
                  'pet_id': _selectedPetId!,
                  'food': foodController.text,
                  'type': selectedType,
                  'amount': double.parse(amountController.text),
                  'unit': selectedUnit,
                  'date': DateFormat('MM/dd/yyyy').format(selectedDate),
                  'time': selectedTime.format(context),
                };
                await DatabaseHelper.updateFeedingLog(updatedLog);
                Navigator.of(context).pop();
                _loadFeedings();
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  //deletes a feeding log
  Future<void> _deleteFeeding(int index) async {
    String? idStr = _feedings[index]['id'];
    if (idStr != null) {
      int id = int.parse(idStr);
      await DatabaseHelper.deleteFeedingLog(id);
      _loadFeedings();
    }
  }

  //displays the logs for the selected day
  void _viewLogsForDay(int dayIndex) {
    _filterFeedingsByDay(dayIndex);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logs for ${weekdays[dayIndex]}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _filteredFeedings.length,
              itemBuilder: (context, index) {
                final feeding = _filteredFeedings[index];
                return ListTile(
                  title: Text(
                    '${feeding['food']} - ${feeding['amount']} ${feeding['unit']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    '${feeding['type']} at ${feeding['time']}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final backgroundColor =
            themeProvider.isDarkMode ? Colors.black : Colors.white;
        final appBarColor =
            themeProvider.isDarkMode ? Colors.grey[900]! : Colors.orange;
        final activeCardColor = themeProvider.isDarkMode
            ? Colors.orange
            : const Color.fromARGB(255, 244, 189, 118);
        final inactiveCardColor = themeProvider.isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(228, 252, 239, 165);
        final activeTextColor =
            themeProvider.isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: activeTextColor),
              onPressed: () =>
                  Navigator.pushNamed(context, '/home', arguments: widget.petId),
            ),
            title: Text(
              'Feeding Schedule',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: activeTextColor),
            ),
          ),
          body: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: activeCardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Feeding Tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: activeTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekdays.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isHighlighted = index == _getDayIndex(_selectedDate);
                    return GestureDetector(
                      onTap: () => _viewLogsForDay(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 70,
                        width: 50,
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? activeCardColor
                              : inactiveCardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekdays[index],
                              style: TextStyle(
                                color: isHighlighted
                                    ? activeTextColor
                                    : (themeProvider.isDarkMode
                                        ? Colors.orange
                                        : Colors.black),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _feedings.length,
                  itemBuilder: (context, index) {
                    final feeding = _feedings[index];
                    return Card(
                      color: inactiveCardColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(
                          '${feeding['food']} - ${feeding['amount']} ${feeding['unit']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${feeding['type']} on ${feeding['date']} at ${feeding['time']}',
                          style: TextStyle(
                              fontSize: 14,
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editFeeding(index);
                            } else if (value == 'delete') {
                              _deleteFeeding(index);
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
            onPressed: _addFeeding,
            splashColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: themeProvider.isDarkMode ? Colors.orange : activeCardColor,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
