import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ExamService {
  final String baseUrl = 'http://10.0.2.2:3000/api';

  // Create a new exam
  Future<Map<String, dynamic>> createExam(String courseId, String instructorId, Uint8List? examFile, String? mimeType) async {
    final url = Uri.parse('$baseUrl/exam');
    final request = http.MultipartRequest('POST', url);

    // Add fields to the request
    request.fields['courseId'] = courseId;
    request.fields['instructorId'] = instructorId;

    // If an exam file is provided, add it to the request
    if (examFile != null && mimeType != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'examFile',
        examFile,
        filename: 'examFile',
        contentType: MediaType.parse(mimeType),
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to create exam: ${responseBody}');
    }
  }

  // Add a response to an exam
  Future<Map<String, dynamic>> addResponse(String examId, String userId, String responseBody) async {
    final url = Uri.parse('$baseUrl/exam/response/$examId/$userId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'responseBody': responseBody}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add response: ${response.body}');
    }
  }

  // Get an exam by examId
  Future<Map<String, dynamic>> getExam(String examId) async {
    final url = Uri.parse('$baseUrl/exam/$examId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve exam: ${response.body}');
    }
  }

  // Get an exam by courseId
  Future<Map<String, dynamic>> getExamByCourseId(String courseId) async {
    final url = Uri.parse('$baseUrl/exam/course/$courseId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve exam by course ID: ${response.body}');
    }
  }
}
