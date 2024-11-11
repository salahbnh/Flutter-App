import 'package:flutter/material.dart';
import 'forumModels.dart';
import 'forumService.dart';
import 'forum_response_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailPage extends StatefulWidget {
  final String postId;

  PostDetailPage({required this.postId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<ForumPost> _postFuture;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  void _fetchPostDetails() {
    _postFuture = ForumService().fetchPostDetails(widget.postId);
  }

  Future<void> _addResponse(String responseContent) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/forumresponse/responses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': widget.postId,
        'responseContent': responseContent,
        'author': 'Anonymous', // Set author if needed, or get from user data
      }),
    );

    if (response.statusCode == 201) {
      // Successfully created, refresh responses
      _fetchPostDetails();
      setState(() {});
    } else {
      // Handle error
      print('Failed to create response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Colors.blue[900],
        elevation: 4,
      ),
      body: FutureBuilder<ForumPost>(
        future: _postFuture,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (postSnapshot.hasError) {
            return Center(child: Text('Error: ${postSnapshot.error}'));
          } else if (!postSnapshot.hasData) {
            return Center(child: Text('No post found'));
          } else {
            ForumPost post = postSnapshot.data!;

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildPostDetails(post),
                SizedBox(height: 20),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddResponseDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Builds the post details (title, content, etc.)
  Widget _buildPostDetails(ForumPost post) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Set mainAxisSize to MainAxisSize.min
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'By: ${post.author} | Views: ${post.views} | Type: ${post.type}',
                    style: TextStyle(color: Colors.grey[900], fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    post.content,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Posted on: ${post.createdAt.toLocal().toString()}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 300, // Adjust height as needed for your layout
            child: ForumResponsesWidget(postId: post.id),
          ),
        ],
      ),
    );
  }

  void _showAddResponseDialog() {
    final _responseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
          Text('Add Response', style: TextStyle(color: Colors.blue[900])),
          content: TextField(
            controller: _responseController,
            decoration: InputDecoration(
              hintText: 'Enter your response...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.blue[900])),
            ),
            TextButton(
              onPressed: () async {
                final responseContent = _responseController.text.trim();
                if (responseContent.isNotEmpty) {
                  await _addResponse(responseContent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Send', style: TextStyle(color: Colors.blue[900])),
            ),
          ],
        );
      },
    );
  }
}