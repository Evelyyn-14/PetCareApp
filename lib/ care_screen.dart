import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class CareScreen extends StatefulWidget {
  final int petId;
  const CareScreen({Key? key, required this.petId}) : super(key: key);

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      //uses consumer to listen to theme changes
      builder: (context, themeProvider, child) {
        final backgroundColor =
            themeProvider.isDarkMode ? Colors.black : Colors.white;
        final appBarColor =
            themeProvider.isDarkMode ? Colors.grey[900]! : Colors.orange;
        final headerContainerColor = themeProvider.isDarkMode
            ? Colors.orange
            : const Color.fromARGB(255, 244, 189, 118);
        final cardContainerColor = themeProvider.isDarkMode
            ? Colors.grey[800]!
            : const Color.fromARGB(228, 252, 239, 165);
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
                    margin: const EdgeInsets.only(top: 10),
                    width: 250,
                    height: 70,
                    decoration: BoxDecoration(
                      color: headerContainerColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Cat Care Tips',
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
                Text(
                  '-- Basic Tips --',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final List<Map<String, String>> tips = [
                      {
                        "heading": "Litter Box Maintenance",
                        "paragraph":
                            "Keep the litter box clean, in an accessible location. Scoop daily and change the litter regularly to prevent odor."
                      },
                      {
                        "heading": "Balanced Diet",
                        "paragraph":
                            "Feed your cat high-quality food appropriate for their age, weight, and activity level."
                      },
                      {
                        "heading": "Routine Grooming",
                        "paragraph":
                            "Brush your cat regularly, especially if they have long fur. This helps reduce hairballs and keep their coat shiny."
                      },
                      {
                        "heading": "Vet Check-Ups",
                        "paragraph":
                            "Schedule routine check-ups and vaccinations. Early detection of issues can make a big difference."
                      },
                    ];
                    return Container(
                      decoration: BoxDecoration(
                        color: cardContainerColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Text(
                            tips[index]["heading"]!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            tips[index]["paragraph"]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  '-- Common Illnesses --',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: cardContainerColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upper Respiratory Infections (URI)",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Symptoms include sneezing, nasal congestion, watery eyes, and fever. Consult a vet for treatment.",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
