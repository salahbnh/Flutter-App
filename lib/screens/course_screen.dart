import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> course = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(course['description']!),
            const SizedBox(height: 20),
            // Add more details or actions related to the course
            ElevatedButton(
              onPressed: () {
                // Action for enrolling in the course or similar
              },
              child: const Text('Enroll in Course'),
            ),
          ],
        ),
      ),
    );
  }
}
