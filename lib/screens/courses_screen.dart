import 'package:flutter/material.dart';
import 'CourseDetailsScreen.dart'; // Import your course details screen
import 'package:flutter/cupertino.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the title and description here
    final String courseTitle = 'Course Title';
    final String courseDescription = 'This is a brief description of the course.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns the layout to the top left
          mainAxisSize: MainAxisSize.min, // Makes sure the column takes up minimal space
          children: [
            GestureDetector(
              onTap: () {
                // Use CupertinoPageRoute for the transition and pass title and description
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CourseDetailsScreen(
                      title: courseTitle,
                      description: courseDescription,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5, // Adds some shadow effect to the card
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Adds padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
                    children: [
                      Image.asset(
                        'assets/images/moodle.png', // Your course image here
                        height: 100, // Adjust the image height
                        width: double.infinity, // Make it full width
                        fit: BoxFit.cover, // Adjust image fit
                      ),
                      const SizedBox(height: 10), // Space between image and text
                      const Text(
                        'Course Title',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10), // Space between title and description
                      const Text(
                        'This is a brief description of the course.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
