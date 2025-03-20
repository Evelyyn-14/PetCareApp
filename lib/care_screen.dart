import 'package:flutter/material.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Null
        )
      ),
      body: Column(
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
                  'Cat Care Tips',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
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
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final List<Map<String, String>> tips = [
                  {
                    "heading": "Litter Box Maintenance",
                    "paragraph": "Keep the litter box clean and in quiet, accessible location. Scoop daily and change the litter regularly to prevent odor and encourage proper use."
                  },
                  {
                    "heading": "Balanced Diet",
                    "paragraph": "Feed your cat high-quality food appropriate for their age, weight, and activity level."
                  },
                  {
                    "heading": "Routine Grooming",
                    "paragraph": "Brush your cat regularly, especially if they have long fur. This helps reduce hairballs and keep their coat shiny."
                  },
                  {
                    "heading": "Vet Check-Ups",
                    "paragraph": "Schedule routine check-ups and vaccinations. Early detection of issues like dental problems, parasites, or infections can make a big difference."
                  },
                ];
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(228, 252, 239, 165),
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
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        tips[index]["paragraph"]!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}