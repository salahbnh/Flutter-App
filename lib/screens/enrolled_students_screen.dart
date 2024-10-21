import 'package:flutter/material.dart';

class EnrolledStudentsScreen extends StatelessWidget {
  final List<String> enrolledStudents;

  EnrolledStudentsScreen({required this.enrolledStudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Students'),
        backgroundColor: Colors.teal, // Custom color for AppBar
      ),
      body: ListView.builder(
        itemCount: enrolledStudents.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Card margin
            elevation: 4.0, // Elevation for shadow effect
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0), // Padding inside ListTile
              title: Text(
                enrolledStudents[index],
                style: const TextStyle(
                  fontSize: 18, // Increased font size
                  fontWeight: FontWeight.bold, // Bold font
                ),
              ),
              trailing: const Icon(Icons.check, color: Colors.teal), // Checkmark icon
            ),
          );
        },
      ),
    );
  }
}
