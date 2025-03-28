import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class FeedingScreen extends StatefulWidget {
  final int petId; // Ensure petId is passed when navigating to this screen

  const FeedingScreen({super.key, required this.petId});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  int? _selectedPetId;
  List<Map<String, String>> _feedings = [];
  List<Map<String, String>> _filteredFeedings = [];

  List<String> weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  Color activeCardColor = Color.fromARGB(255, 244, 189, 118);
  Color inactiveCardColor = Color.fromARGB(228, 252, 239, 165);

  Color activeTextColor = Colors.black;
  Color inactiveTextColor = Colors.white;

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

  int _getDayIndex(DateTime date) {
    return date.weekday - 1; // Convert to 0-based index (Monday = 0, Sunday = 6)
  }

  void _filterFeedingsByDay(int dayIndex) {
    setState(() {
      _filteredFeedings = _feedings.where((feeding) {
        DateTime feedingDate = DateFormat('MM/dd/yyyy').parse(feeding['date']!);
        return _getDayIndex(feedingDate) == dayIndex;
      }).toList();
    });
  }

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
          title: Text(
            'Add New Feeding Log',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Food input
                TextField(
                  controller: foodController,
                  decoration: InputDecoration(labelText: 'Food'),
                ),
                // Type selection
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButton<String>(
                        value: _selectedType,
                        items: [
                          DropdownMenuItem(child: Text('Food'), value: 'Food'),
                          DropdownMenuItem(child: Text('Water'), value: 'Water'),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                        hint: Text('Select Type'),
                      );
                    },
                  ),
                ),
                // Amount and Unit
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return DropdownButton<String>(
                          value: _selectedUnit,
                          items: [
                            DropdownMenuItem(child: Text('Grams'), value: 'Grams'),
                            DropdownMenuItem(child: Text('Milliliters'), value: 'Milliliters'),
                            DropdownMenuItem(child: Text('Ounces'), value: 'Ounces'),
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
                // Date picker
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
                // Time picker
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
                // Insert into database
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
              child: Text('Add Log'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editFeeding(int index) async {
    Map<String, String> feeding = _feedings[index];
    TextEditingController foodController = TextEditingController(text: feeding['food']);
    TextEditingController amountController = TextEditingController(text: feeding['amount']);
    String selectedType = feeding['type']!;
    String selectedUnit = feeding['unit']!;
    // Parse date using the known format
    DateTime selectedDate = DateFormat('MM/dd/yyyy').parse(feeding['date']!);
    // Parse time (assuming format like '10:30 AM')
    List<String> timeParts = feeding['time']!.split(RegExp('[: ]'));
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Feeding Log'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: foodController,
                      decoration: InputDecoration(labelText: 'Food'),
                    ),
                    DropdownButton<String>(
                      value: selectedType,
                      items: [
                        DropdownMenuItem(child: Text('Food'), value: 'Food'),
                        DropdownMenuItem(child: Text('Water'), value: 'Water'),
                        DropdownMenuItem(child: Text('Medicine'), value: 'Medicine'),
                        DropdownMenuItem(child: Text('Treat'), value: 'Treat'),
                        DropdownMenuItem(child: Text('Other'), value: 'Other'),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                      hint: Text('Select Type'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedUnit,
                          items: [
                            DropdownMenuItem(child: Text('Grams'), value: 'Grams'),
                            DropdownMenuItem(child: Text('Milliliters'), value: 'Milliliters'),
                            DropdownMenuItem(child: Text('Ounces'), value: 'Ounces'),
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
                // Build the updated feeding log map
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
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFeeding(int index) async {
    String? idStr = _feedings[index]['id'];
    if (idStr != null) {
      int id = int.parse(idStr);
      await DatabaseHelper.deleteFeedingLog(id);
      _loadFeedings();
    }
  }

  void _viewLogsForDay(int dayIndex) {
    _filterFeedingsByDay(dayIndex);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logs for ${weekdays[dayIndex]}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    '${feeding['type']} at ${feeding['time']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int highlightedDayIndex = _getDayIndex(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home',arguments: widget.petId),
        ),
        title: Text(
          'Feeding Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: activeCardColor,
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
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekdays.length,
              itemBuilder: (BuildContext context, int index) {
                bool isHighlighted = index == highlightedDayIndex;
                return GestureDetector(
                  onTap: () => _viewLogsForDay(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 70,
                    width: 50,
                    decoration: BoxDecoration(
                      color: isHighlighted ? activeCardColor : inactiveCardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekdays[index],
                          style: TextStyle(
                            color: isHighlighted ? activeTextColor : inactiveTextColor,
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
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      '${feeding['food']} - ${feeding['amount']} ${feeding['unit']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${feeding['type']} on ${feeding['date']} at ${feeding['time']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editFeeding(index);
                        } else if (value == 'delete') {
                          _deleteFeeding(index);
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
        onPressed: _addFeeding,
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: activeCardColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
