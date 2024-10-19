import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';

class CoursesScreen extends StatelessWidget {
   const CoursesScreen({super.key});

  final List<Map<String, String>> courses = const [
    {'title': 'Course 1', 'description': 'Description for Course 1'},
    {'title': 'Course 2', 'description': 'Description for Course 2'},
    {'title': 'Course 3', 'description': 'Description for Course 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(courses[index]['title']!),
              subtitle: Text(courses[index]['description']!),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/course-details',
                    arguments: courses[index],
                  );
                },
                child: const Text('View Details'),
              ),
            ),
          );
        },
      ),
    );
  }
}
