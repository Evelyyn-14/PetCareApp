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
          onPressed: () => Navigator.pushNamed(context, '/home'
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10),
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
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                    "paragraph": "Keep the litter box clean, in an accessible location. Scoop daily and change the litter regularly to prevent odor."
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
                      SizedBox(height: 14),
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
            SizedBox(height: 30),
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
            SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(228, 252, 239, 165),
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
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Symptoms include sneezing, nasal congestion, watery eyes, and Fever. May be caused by viruses or bacteria. Consult a vet for treatment.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(228, 252, 239, 165),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Feline Lower Urinary Tract Disease (FLUTD)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Symptoms include frequent or painful urination and blood in the urine. It can be caused by urinary crystals, bladder stones, or infections. Consult a vet for diagnosis and treatment.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(228, 252, 239, 165),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Feline Dental Disease",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Symptoms include bad breath, difficulty eating, and drooling. Make sure to brush your cat's teeth regularly and provide dental treats. Consult a vet for professional cleaning.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
  }
}