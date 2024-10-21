import 'package:flutter/material.dart';
import 'AddCourseScreen.dart'; // Ensure this import is included
import 'dashboard_screen.dart'; // Import the dashboard screen
import 'enrolled_students_screen.dart';

class CourseListingScreen extends StatefulWidget {
  @override
  _CourseListingScreenState createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  // List to hold courses
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> filteredCourses = []; // New list for filtered courses
  TextEditingController searchController = TextEditingController(); // Controller for the search bar

  @override
  void initState() {
    super.initState();
    filteredCourses = courses; // Initially show all courses
  }

  // Method to add a course
  void _addCourse(String title, String description) {
    setState(() {
      courses.add({
        'title': title,
        'description': description,
        'enrolledStudents': [], // Initialize as an empty list
      });
      filteredCourses = courses; // Update filtered courses
    });
  }

  // Method to delete a course
  void _deleteCourse(int index) {
    setState(() {
      courses.removeAt(index);
      filteredCourses = courses; // Update filtered courses
    });
  }

  // Method to edit a course
  void _editCourse(int index, String title, String description) {
    setState(() {
      courses[index] = {
        'title': title,
        'description': description,
        'enrolledStudents': courses[index]['enrolledStudents'], // Retain enrolled students
      };
      filteredCourses = courses; // Update filtered courses
    });
  }

  // Method to filter courses based on search input
  void _filterCourses(String query) {
    setState(() {
      filteredCourses = courses.where((course) {
        final titleLower = course['title'].toLowerCase();
        final descriptionLower = course['description'].toLowerCase();
        return titleLower.contains(query.toLowerCase()) ||
            descriptionLower.contains(query.toLowerCase());
      }).toList();
    });
  }

  // Method to add student to a course
  void _addStudentToCourse(int courseIndex) {
    String studentName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Student'),
          content: TextField(
            onChanged: (value) {
              studentName = value; // Capture the student name
            },
            decoration: const InputDecoration(hintText: 'Enter student name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (studentName.isNotEmpty) {
                  setState(() {
                    courses[courseIndex]['enrolledStudents'].add(studentName); // Add student name to the list
                  });
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without adding
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to view enrolled students
  void _viewEnrolledStudents(int courseIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enrolled Students'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var student in courses[courseIndex]['enrolledStudents'])
                Text(student),
              if (courses[courseIndex]['enrolledStudents'].isEmpty)
                const Text('No students enrolled.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Method to navigate to the Dashboard
  void _goToDashboard() {
    Navigator.pushNamed(
      context,
      '/dashboard',
      arguments: {
        'totalCourses': courses.length,
        'totalStudents': courses.fold<int>(
          0,
              (sum, course) => sum + (course['enrolledStudents'].length as int), // Explicitly cast to int
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        backgroundColor: Colors.teal, // Custom color for AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to AddCourseScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCourseScreen(onCourseAdded: _addCourse),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.dashboard), // Dashboard icon
            onPressed: _goToDashboard, // Navigate to Dashboard
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterCourses, // Filter courses on input
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200], // Background color for search bar
                hintText: 'Search Courses',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none, // Remove border
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredCourses.length, // Use filtered courses
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            elevation: 5, // Shadow effect
            child: ListTile(
              title: Text(
                filteredCourses[index]['title']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Title color
                ),
              ),
              subtitle: Text(
                filteredCourses[index]['description']!,
                style: TextStyle(color: Colors.grey[700]), // Subtitle color
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to AddCourseScreen for editing
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCourseScreen(
                            onCourseAdded: (title, description) {
                              _editCourse(index, title, description);
                              Navigator.pop(context); // Go back after editing
                            },
                            title: filteredCourses[index]['title']!,
                            description: filteredCourses[index]['description']!,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteCourse(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add), // Add People icon
                    onPressed: () {
                      _addStudentToCourse(index); // Call the method to add a student
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.people), // List Enrolled Students icon
                    onPressed: () {
                      _viewEnrolledStudents(index); // Call the method to view enrolled students
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




