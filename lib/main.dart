import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/course_screen.dart';
import 'screens/assignment_screen.dart'; // Import the new screen
import 'screens/evaluation_screen.dart'; // Import the new screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moodle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/course': (context) => const CourseScreen(),
        '/assignments': (context) => const AssignmentScreen(), // Add this line
        '/evaluations': (context) => const EvaluationScreen(), // Add this line
      },
    );
  }
}
