import 'package:flutter/material.dart';
import 'payment_screen.dart'; // Import the PaymentScreen

class ResumeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> resume;

  ResumeDetailsPage({required this.resume});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(resume['title']),
          bottom: TabBar(
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Modules'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // About Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title: ${resume['title']}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Level: ${resume['classLevel']}",
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Reference: ${resume['reference']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Owner: ${resume['owner']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Price: \$${resume['price']}",
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Resume Description",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        resume['description'] ?? "No description available.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modules Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Modules",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: resume['modules']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final module = resume['modules'][index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(module['title']),
                                subtitle: Text(module['description']),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Reviews Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reviews",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: resume['reviews']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final review = resume['reviews'][index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(review['username']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review['comment']),
                                    Text("Rating: ${review['rating']}/5", style: TextStyle(fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button color
              padding: EdgeInsets.symmetric(vertical: 16.0), // Button padding
            ),
            onPressed: () {
              // Navigate to the PaymentScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(resume: resume),
                ),
              );
            },
            child: Text("Proceed to Purchase", style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
