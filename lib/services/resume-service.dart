import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ResumeService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Change to your backend URL

  // Function to add a new resume
  Future<bool> addResume(Map<String, dynamic> resumeData) async {
    final url = Uri.parse('$baseUrl/api/resumes');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resumeData),
      );

      return response.statusCode == 201; // Check if the request was successful
    } catch (error) {
      print('Add Resume error: $error');
      return false;
    }
  }

  // Function to get all resumes
  Future<List<dynamic>> getResumes() async {
    final url = Uri.parse('$baseUrl/api/resumes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the list of resumes
      } else {
        return [];
      }
    } catch (error) {
      print('Get Resumes error: $error');
      return [];
    }
  }

  // Function to rate a resume
  Future<bool> rateResume(String resumeId, double rating, String comment) async {
    final url = Uri.parse('$baseUrl/api/resumes/rate');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Get the token from shared preferences

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token for authorization
        },
        body: jsonEncode({
          'resumeId': resumeId,
          'rating': rating,
          'comment': comment,
        }),
      );

      return response.statusCode == 200; // Check if the request was successful
    } catch (error) {
      print('Rate Resume error: $error');
      return false;
    }
  }
}
