import 'package:http/http.dart' as http;
import 'dart:convert';
import 'forumModels.dart';

class ForumService {
  String apiUrl = 'http://10.0.2.2:3000/api'; // Replace with your API URL

// Fetch post details by ID
  Future<ForumPost> fetchPostDetails(String postId) async {
    final response =
    await http.get(Uri.parse('$apiUrl/forumpost/posts/$postId'));

    if (response.statusCode == 200) {
      return ForumPost.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post details');
    }
  }

// Fetch responses for the post
  Future<List<Map<String, dynamic>>> getResponsesForPost(String postId) async {
    final url = Uri.parse('$apiUrl/forumresponse/responses/$postId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((response) => response as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to load responses');
      }
    } catch (error) {
      print('Error fetching responses: $error');
      return [];
    }
  }
}