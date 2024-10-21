import 'package:flutter/material.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of assignments
    final List<Map<String, String>> assignments = [
      {'title': 'Assignment 1', 'description': 'Complete the first assignment by next week.'},
      {'title': 'Assignment 2', 'description': 'Prepare a report on the topic discussed in class.'},
      // Add more assignments as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(assignments[index]['title']!),
              subtitle: Text(assignments[index]['description']!),
              onTap: () {
                // Navigate to assignment details if needed
              },
            ),
          );
        },
      ),
    );
  }
}
