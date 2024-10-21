import 'package:flutter/material.dart';

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of evaluations
    final List<Map<String, String>> evaluations = [
      {'title': 'Midterm Exam', 'description': 'Covers chapters 1-5.'},
      {'title': 'Final Exam', 'description': 'Comprehensive final exam.'},
      // Add more evaluations as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluations'),
      ),
      body: ListView.builder(
        itemCount: evaluations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(evaluations[index]['title']!),
              subtitle: Text(evaluations[index]['description']!),
              onTap: () {
                // Navigate to evaluation details if needed
              },
            ),
          );
        },
      ),
    );
  }
}
