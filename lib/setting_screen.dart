import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingScreen extends StatefulWidget {
  final int petId;
  const SettingScreen({Key? key, required this.petId}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _nightMode = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final backgroundColor =
            themeProvider.isDarkMode ? Colors.black : Colors.white;
        final appBarColor =
            themeProvider.isDarkMode ? Colors.grey[900] : Colors.orange;
        final containerColor = themeProvider.isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(228, 252, 239, 165);
        final buttonColor = themeProvider.isDarkMode
            ? Colors.orange
            : Colors.orangeAccent;
        final textColor =
            themeProvider.isDarkMode ? Colors.white : Colors.black;
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () =>
                  Navigator.pushNamed(context, '/home', arguments: widget.petId),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? Colors.orange
                          : const Color.fromARGB(255, 244, 189, 118),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.pets, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Placeholder',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      ListTile(
                        title: Text(
                          'Night Mode',
                          style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/welcome');
                        },
                        icon: const Icon(Icons.switch_account),
                        label: const Text('Switch Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
