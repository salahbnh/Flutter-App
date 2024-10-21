import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/CourseListingScreen.dart';
import 'screens/AddCourseScreen.dart';
import 'screens/CourseListingScreen.dart';
import 'screens/dashboard_screen.dart';

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
      initialRoute: '/courses_listing',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/courses_listing': (context) =>  CourseListingScreen(),
        '/add_course': (context) => AddCourseScreen(
          onCourseAdded: (title, description) {
            // Add the course to your course listing here if needed
          },
        ),
        '/dashboard': (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DashboardScreen(
            totalCourses: args['totalCourses'], // Pass the actual totalCourses
            totalStudents: args['totalStudents'], // Pass the actual totalStudents
          );
        },
      },
    );
  }
}
