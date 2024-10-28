import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  final String role;
  final Function(String username, String email, String password) onRegister;
  final bool isLoading;

  SignUpForm({
    required this.role,
    required this.onRegister,
    required this.isLoading,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // Validation logic
  bool validateForm() {
    bool isValid = true;

    setState(() {
      // Reset errors
      usernameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;

      // Username validation
      if (usernameController.text.isEmpty) {
        usernameError = 'Username is required';
        isValid = false;
      }

      // Email validation
      if (emailController.text.isEmpty) {
        emailError = 'Email is required';
        isValid = false;
      } else if (!RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text)) {
        emailError = 'Invalid email format';
        isValid = false;
      }

      // Password validation
      if (passwordController.text.isEmpty) {
        passwordError = 'Password is required';
        isValid = false;
      } else if (passwordController.text.length < 6) {
        passwordError = 'Password must be at least 6 characters';
        isValid = false;
      }

      // Confirm Password validation
      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = 'Please confirm your password';
        isValid = false;
      } else if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
        isValid = false;
      }
    });

    return isValid;
  }

  void validateAndSubmit() {
    if (validateForm()) {
      widget.onRegister(
        usernameController.text,
        emailController.text,
        passwordController.text,
      );
    }
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

        // Username field
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            errorText: usernameError,
          ),
        ),
        const SizedBox(height: 8),

        // Email field
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: emailError,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 8),

        // Password field
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: passwordError,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 8),

        // Confirm Password field
        TextField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            errorText: confirmPasswordError,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),

        // Register button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : validateAndSubmit,
            child: widget.isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
