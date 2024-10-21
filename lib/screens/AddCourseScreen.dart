import 'package:flutter/material.dart';

class AddCourseScreen extends StatelessWidget {
  final Function(String, String) onCourseAdded;
  final String? title; // Field for editing
  final String? description; // Field for editing

  AddCourseScreen({required this.onCourseAdded, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController descriptionController = TextEditingController(text: description);

    return Scaffold(
      appBar: AppBar(
        title: Text(title != null ? 'Edit Course' : 'Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Course Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add or edit the course and return the data
                onCourseAdded(titleController.text, descriptionController.text);
                Navigator.pop(context, true); // Indicate that changes were made
              },
              child: const Text('Save Course'),
            ),
          ],
        ),
      ),
    );
  }
}
