import 'package:flutter/material.dart';
import 'database_helper.dart';

class CatProfile {
  final String name;
  final String age;
  final String gender;

  CatProfile({required this.name, required this.age, required this.gender});
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
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper.init();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final profiles = await _dbHelper.queryAllRows();
    setState(() {
      _catProfiles.addAll(profiles.map((profile) => CatProfile(
        name: profile['name'],
        age: profile['age'].toString(),
        gender: profile['gender'],
      )).toList());
    });
  }

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
                  final newProfile = CatProfile(
                    name: _nameController.text,
                    age: _ageController.text,
                    gender: _genderController.text,
                  );
                  _catProfiles.add(newProfile);
                  _dbHelper.insert({
                    'name': newProfile.name,
                    'age': int.parse(newProfile.age),
                    'gender': newProfile.gender,
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openProfile(CatProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailScreen(profile: profile),
      ),
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
                  onTap: () => _openProfile(catProfileInfo),
                  child: Column(
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

class ProfileDetailScreen extends StatelessWidget {
  final CatProfile profile;

  const ProfileDetailScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile.name}', style: TextStyle(fontSize: 20)),
            Text('Age: ${profile.age}', style: TextStyle(fontSize: 20)),
            Text('Gender: ${profile.gender}', style: TextStyle(fontSize: 20)),
            // Add more details or actions here
          ],
        ),
      ),
    );
  }
}