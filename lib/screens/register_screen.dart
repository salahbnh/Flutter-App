import 'package:flutter/material.dart';
import '/widgets/role_selection.dart';
import '/widgets/signup_form.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  String role = '';
  bool isLoading = false;

  Future<void> onRegister(String username, String email, String password) async {
    setState(() {
      isLoading = true;
    });

    // Attempt to sign up the user
    bool success = await authService.signup(username, email, password, role);

    setState(() {
      isLoading = false;
    });

    if (success) {
      // Navigate to the home page if registration is successful
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show an alert dialog if signup failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content: Text('Could not sign up. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (role.isEmpty)
              RoleSelection(
                onStudentSelected: () {
                  setState(() {
                    role = 'Student';
                  });
                },
                onInstructorSelected: () {
                  setState(() {
                    role = 'Instructor';
                  });
                },
              ),
            if (role.isNotEmpty)
              SignUpForm(
                role: role,
                onRegister: onRegister,
                isLoading: isLoading, // Pass loading state to form
              ),
          ],
        ),
      ),
    );
  }
}
