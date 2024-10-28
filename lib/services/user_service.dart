import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000';

  // Signup function to register a new user
  Future<bool> signup(String username, String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/api/user/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        // Parse response and store user data locally
        final data = jsonDecode(response.body);
        print(data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(data['user']));
        await prefs.setString('token', data['token']);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Signup error: $error');
      return false;
    }
  }

  // Login function
  Future<bool> login(String emailOrUsername, String password) async {
    final url = Uri.parse('$baseUrl/api/user/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailOrUsername': emailOrUsername,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse response and store user data locally
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(data['user']));
        await prefs.setString('token', data['token']);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Login error: $error');
      return false;
    }
  }
}
