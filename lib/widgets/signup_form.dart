import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  final String role;
  final Function(String username, String email, String password) onRegister;

  SignUpForm({required this.role, required this.onRegister});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String usernameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$").hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  void validateAndSubmit() {
    setState(() {
      usernameError = '';
      emailError = '';
      passwordError = '';
      confirmPasswordError = '';

      if (usernameController.text.isEmpty) {
        usernameError = 'Username is required';
      }
      if (!isEmailValid(emailController.text)) {
        emailError = 'Please enter a valid email';
      }
      if (!isPasswordValid(passwordController.text)) {
        passwordError = 'Password must be at least 6 characters';
      }
      if (passwordController.text != confirmPasswordController.text) {
        confirmPasswordError = 'Passwords do not match';
      }

      if (usernameError.isEmpty && emailError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty) {
        widget.onRegister(usernameController.text, emailController.text, passwordController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register as ${widget.role}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text('Username', style: TextStyle(fontSize: 16)),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Enter your username',
            border: const OutlineInputBorder(),
            errorText: usernameError.isNotEmpty ? usernameError : null,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Email', style: TextStyle(fontSize: 16)),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            border: const OutlineInputBorder(),
            errorText: emailError.isNotEmpty ? emailError : null,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Password', style: TextStyle(fontSize: 16)),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            border: const OutlineInputBorder(),
            errorText: passwordError.isNotEmpty ? passwordError : null,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Confirm Password', style: TextStyle(fontSize: 16)),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            border: const OutlineInputBorder(),
            errorText: confirmPasswordError.isNotEmpty ? confirmPasswordError : null,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 400,
          child: ElevatedButton(
            onPressed: validateAndSubmit,
            child: Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue[800]),
            ),
          ),
        ),
      ],
    );
  }
}
