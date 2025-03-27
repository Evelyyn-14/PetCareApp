import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                        Navigator.pushNamed(context, '/feeding');
                      }
                      if (index == 1) {
                        Navigator.pushNamed(context, '/care');
                      }
                      if (index == 3) {
                        Navigator.pushNamed(context, '/reminder');
                      }
                      if (index == 4) {
                        Navigator.pushNamed(context, '/setting');
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(228, 252, 239, 165),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          icons[index],
                          size: 50,
                          color: Colors.black,
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