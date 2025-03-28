import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class CatProfile {
  final int id;
  final String name;
  final String age;
  final String gender;

  CatProfile({required this.id, required this.name, required this.age, required this.gender});
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  final List<CatProfile> _catProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  //loads profiles from the database
  Future<void> _loadProfiles() async {
    final profiles = await DatabaseHelper.queryAllRows('pets');
    setState(() {
      _catProfiles.addAll(profiles.map((profile) => CatProfile(
        id: profile['id'],
        name: profile['name'],
        age: profile['age'].toString(),
        gender: profile['gender'],
      )));
    });
  }

  //saves profiles to the database
  void _saveProfile() async {
    final data = {
      'name': _nameController.text,
      'age': double.parse(_ageController.text),
      'gender': _selectedGender,
    };
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    await db.insert('pets', data);
  }

  //deletes profiles from the database
  Future<void> _deleteProfile(int index, String name) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('pets', where: 'name = ?', whereArgs: [name]);
    setState(() {
      _catProfiles.removeAt(index);
    });
  }

  //edits profiles in the database
  Future<void> _editProfile(int index, String name) async {
    final updatedName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editNameController =
            TextEditingController(text: name);
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: editNameController,
            decoration: const InputDecoration(labelText: 'Cat Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(editNameController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedName != null && updatedName.isNotEmpty) {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'pets',
        {'name': updatedName},
        where: 'name = ?',
        whereArgs: [name],
      );
      setState(() {
        _catProfiles[index] = CatProfile(
          id: _catProfiles[index].id,
          name: updatedName,
          age: _catProfiles[index].age,
          gender: _catProfiles[index].gender,
        );
      });
    }
  }

  //adds a new profile
  void _addProfile() {
    _nameController.clear();
    _ageController.clear();
    _selectedGender = 'Male'; // Reset gender selection

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Cat Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Cat Name'),
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Cat Age'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Cat Gender'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _catProfiles.add(CatProfile(
                    id: _catProfiles.length + 1,
                    name: _nameController.text,
                    age: _ageController.text,
                    gender: _selectedGender,
                  ));
                });
                _saveProfile();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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
        final headerColor = themeProvider.isDarkMode
            ? Colors.orange
            : Colors.orangeAccent;
        final cardColor = themeProvider.isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(255, 234, 176, 109);
        final textColor =
            themeProvider.isDarkMode ? Colors.white : Colors.black;
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  width: 350,
                  height: 130,
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Welcome to CatCare!',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(40),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: _catProfiles.length,
                  itemBuilder: (context, index) {
                    final catProfileInfo = _catProfiles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                          arguments: catProfileInfo.id,
                        );
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 125,
                                width: 125,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.pets, size: 50),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editProfile(index, catProfileInfo.name);
                                    } else if (value == 'delete') {
                                      _deleteProfile(index, catProfileInfo.name);
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
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(catProfileInfo.name,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textColor)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addProfile(),
            icon: const Icon(Icons.pets),
            label: const Text("Create Cat Profile"),
          ),
        );
      },
    );
  }
}
