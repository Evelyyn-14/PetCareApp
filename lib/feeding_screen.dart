import 'package:flutter/material.dart';
// import 'database_helper.dart';
import 'package:intl/intl.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  List<String> weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  Color activeCardColor = Color.fromARGB(255, 244, 189, 118);
  Color inactiveCardColor = Color.fromARGB(228, 252, 239, 165);

  Color activeTextColor = Colors.black;
  Color inactiveTextColor = Colors.white;

  String _selectedType = 'Food';
  String _selectedUnit = 'Grams';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  List<Map<String, String>> _feedings = [];
  List<Map<String, String>> _filteredFeedings = [];

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

  void _addFeeding() {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    //adds a new feeding log
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add new Feeding Log',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //allows user to input name
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    //allows user to choose type
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
              Row(
                children: [
                  Expanded(
                    //allows user to input amount
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      //allows user to choose unit
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
              //allows user to choose date 
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
              //allows user to choose time
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
              //button to add log
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _feedings.add({
                      'name': nameController.text,
                      'type': _selectedType,
                      'amount': amountController.text,
                      'unit': _selectedUnit,
                      'date': DateFormat('MM/dd/yyyy').format(_selectedDate),
                      'time': _selectedTime.format(context),
                    });
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Add Log'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editFeeding(int index) {
    TextEditingController nameController = TextEditingController(text: _feedings[index]['name']);
    TextEditingController amountController = TextEditingController(text: _feedings[index]['amount']);
    String selectedType = _feedings[index]['type']!;
    String selectedUnit = _feedings[index]['unit']!;
    DateTime selectedDate = DateTime.parse(_feedings[index]['date']!);
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(_feedings[index]['time']!.split(":")[0]),
      minute: int.parse(_feedings[index]['time']!.split(":")[1]),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Log'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
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
                          DropdownMenuItem(child: Text('grams'), value: 'grams'),
                          DropdownMenuItem(child: Text('ounces'), value: 'ounces'),
                          DropdownMenuItem(child: Text('pieces'), value: 'pieces'),
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
                      text: "${selectedDate.toLocal()}".split(' ')[0],
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _feedings[index] = {
                          'name': nameController.text,
                          'type': selectedType,
                          'amount': amountController.text,
                          'unit': selectedUnit,
                          'date': "${selectedDate.toLocal()}".split(' ')[0],
                          'time': selectedTime.format(context),
                        };
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _deleteFeeding(int index) {
    setState(() {
      _feedings.removeAt(index);
    });
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
                    '${feeding['name']} - ${feeding['amount']} ${feeding['unit']}',
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
          onPressed: () => Navigator.pushNamed(context, '/home'),
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
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    height: 70,
                    width: 50,
                    decoration: BoxDecoration(
                      color: isHighlighted ? activeCardColor : inactiveCardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
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
                      '${feeding['name']} - ${feeding['amount']} ${feeding['unit']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${feeding['type']} on ${feeding['date']} at ${feeding['time']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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