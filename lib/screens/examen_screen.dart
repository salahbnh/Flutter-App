import 'package:flutter/material.dart';
import 'teacher_area_screen.dart'; // Import the TeacherAreaScreen

class ExamenScreen extends StatelessWidget {
  final List<Map<String, String>> subjects = [
    {'subject': 'Mathematics', 'teacher': 'Mr. Smith'},
    {'subject': 'Physics', 'teacher': 'Ms. Johnson'},
    {'subject': 'Chemistry', 'teacher': 'Dr. Brown'},
    {'subject': 'Biology', 'teacher': 'Dr. Adams'},
    {'subject': 'History', 'teacher': 'Mr. Green'},
    {'subject': 'Geography', 'teacher': 'Ms. White'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examen'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[800],
                  child: const Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  subjects[index]['subject']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                subtitle: Text(
                  'Teacher: ${subjects[index]['teacher']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue[800],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherAreaScreen(
                        subject: subjects[index]['subject']!,
                        teacher: subjects[index]['teacher']!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
