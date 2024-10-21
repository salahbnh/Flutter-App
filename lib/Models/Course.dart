import 'package:flutter/material.dart';

class EnrolledStudentsScreen extends StatelessWidget {
  final List<String> enrolledStudents; // Pass this data from CourseListingScreen

  const EnrolledStudentsScreen({super.key, required this.enrolledStudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Students'),
      ),
      body: ListView.builder(
        itemCount: enrolledStudents.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(enrolledStudents[index]), // Display student name
            trailing: IconButton(
              icon: const Icon(Icons.remove), // Icon to remove student
              onPressed: () {
                // Functionality to remove the student can be added later
              },
            ),
          );
        },
      ),
    );
  }
}
