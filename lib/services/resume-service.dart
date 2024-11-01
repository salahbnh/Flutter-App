import 'package:http/http.dart' as http;
import 'dart:convert';

class ResumeService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Change to your server's IP if necessary

  Future<bool> addResume(Map<String, dynamic> resumeData, String? pdfFilePath) async {
    final url = Uri.parse('$baseUrl/api/resume'); // Update the endpoint as necessary

    print('Preparing to send resume data: $resumeData'); // Debugging line

    try {
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "title": resumeData['title'],
        "reference": resumeData['reference'],
        "level": resumeData['level'],
        "price": resumeData['price'],
        "owner": resumeData['owner'],
        "description": resumeData['description'],
        // Add filePath if needed, but ensure your API can handle it
        "filePath": pdfFilePath, // Adjust based on how your API handles file uploads
      };

      print('Sending POST request to $url'); // Debugging line

      // Send the POST request with an extended timeout
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(Duration(seconds: 50)); // Increased timeout

      // Log the response status and body
      print('Response status: ${response.statusCode}'); // Log the status
      print('Response body: ${response.body}'); // Log the body

      // Check if the response status code indicates success
      return response.statusCode == 201; // Successful creation
    } catch (error) {
      print('Error adding resume: $error'); // Log the error
      return false; // Return false in case of an error
    }
  }


  Future<List<Map<String, dynamic>>> getAllResumes() async {
    final url = Uri.parse('$baseUrl/api/resume'); // Adjust the endpoint as necessary
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse and return the list of resumes
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to load resumes: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching resumes: $error');
      return [];
    }
  }

  Future<void> addComment(String resumeId, String user, String comment) async {
    final url = '$baseUrl/resume/$resumeId/comment'; // Construct the URL

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': user,
        'comment': comment,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment: ${response.body}');
    }
  }
}
