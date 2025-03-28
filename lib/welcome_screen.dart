import 'package:flutter/material.dart';
import 'database_helper.dart';

class CatProfile {
  final int id; 
  final String name;
  final String age;
  final String gender;

  CatProfile({required this.id, required this.name, required this.age, required this.gender});
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final List<CatProfile> _catProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  //loads saved profiles from the database
  Future<void> _loadProfiles() async {
    final profiles = await DatabaseHelper.queryAllRows('pets');
    setState(() {
      _catProfiles.addAll(profiles.map((profile) => CatProfile(
        id: profile['id'], // Map the id from the database
        name: profile['name'],
        age: profile['age'].toString(),
        gender: profile['gender'],
      )));
    });
  }

  //saves the profile information to the database
  void _saveProfile() async {
    final data = {
      'name': _nameController.text,
      'age': double.parse(_ageController.text),
      'gender': _genderController.text,
    };
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    await db.insert('pets', data);
  }

  //deletes the profile information from the database
  Future<void> _deleteProfile(int index, String name) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('pets', where: 'name = ?', whereArgs: [name]);
    setState(() {
      _catProfiles.removeAt(index);
    });
  }

  //edits the profile information in the database
  Future<void> _editProfile(int index, String name) async {
    final updatedName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editNameController = TextEditingController(text: name);
        return AlertDialog(
          title: Text('Edit Profile'),
          content: TextField(
            controller: editNameController,
            decoration: InputDecoration(labelText: 'Cat Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(editNameController.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    //updates the profile information in the database
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

  //opens a dialog to add a new profile
  void _addProfile() {
    _nameController.clear();
    _ageController.clear();
    _genderController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Cat Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cat Name'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Cat Age'),
              ),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Cat Gender'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _catProfiles.add(CatProfile(
                    id: _catProfiles.length + 1, // Assign a temporary id
                    name: _nameController.text,
                    age: _ageController.text,
                    gender: _genderController.text,
                  ));
                });
                _saveProfile();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
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
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      arguments: catProfileInfo.id, // Pass the petId to the HomeScreen
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 234, 176, 109),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 125,
                            width: 125,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                              icon: Icon(Icons.more_vert),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(catProfileInfo.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
        icon: Icon(Icons.pets),
        label: const Text("Create Cat Profile"),
      ),
    );
  }
}