import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final int totalCourses; // Define totalCourses
  final int totalStudents; // Define totalStudents

  // Constructor to accept parameters
  DashboardScreen({required this.totalCourses, required this.totalStudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Courses: $totalCourses'),
            Text('Total Students: $totalStudents'),
            // Additional dashboard content can be added here
          ],
        ),
      ),
    );
  }
}
