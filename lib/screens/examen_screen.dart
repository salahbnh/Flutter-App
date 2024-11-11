import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'examen_list_screen.dart';

class ExamenScreen extends StatelessWidget {
  late final String role;
  late final String userId;

  final List<Map<String, String>> subjects = [
    {'subject': 'Mathematics', 'teacher': 'Mr. Smith', 'courseId':'1234'},
    {'subject': 'Physics', 'teacher': 'Ms. Johnson', 'courseId':'1234'},
    {'subject': 'Chemistry', 'teacher': 'Dr. Brown', 'courseId':'1234'},
    {'subject': 'Biology', 'teacher': 'Dr. Adams', 'courseId':'1234'},
    {'subject': 'History', 'teacher': 'Mr. Green', 'courseId':'1234'},
    {'subject': 'Geography', 'teacher': 'Ms. White', 'courseId':'1234'},
  ];

  Future<void> _onSubjectTap(BuildContext context, Map<String, String> subject) async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    String role = 'Student'; // Default value
    String userId = '123'; // Default value

    if (userJson != null) {
      final userData = jsonDecode(userJson);
      role = userData['role'] ?? 'Student';
      userId = userData['_id'] ?? '123';
    }

    print('Role: $role'); // Log to verify role
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExamListScreen(
              courseId: subject['courseId']!,
              subjectName: subject['subject']!,
              isStudent: role == 'Student',
              userId: userId,
            ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index]['subject']!),
            subtitle: Text('Teacher: ${subjects[index]['teacher']}'),
            onTap: () => _onSubjectTap(context, subjects[index]),
          );
        },
      ),
    );
  }
}