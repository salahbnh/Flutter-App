import 'package:flutter/material.dart';

import 'forumService.dart';

class ForumResponsesWidget extends StatefulWidget {
  final String postId;

  const ForumResponsesWidget({Key? key, required this.postId})
      : super(key: key);

  @override
  _ForumResponsesWidgetState createState() => _ForumResponsesWidgetState();
}

class _ForumResponsesWidgetState extends State<ForumResponsesWidget> {
  late Future<List<Map<String, dynamic>>> _responsesFuture;

  @override
  void initState() {
    super.initState();
    _responsesFuture = ForumService().getResponsesForPost(widget.postId);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _responsesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No responses found.'));
        } else {
          List<Map<String, dynamic>> responses = snapshot.data!;
          return Flexible(
            child: ListView.builder(
              itemCount: responses.length,
              itemBuilder: (context, index) {
                final response = responses[index];
                return ListTile(
                  title: Text(response['author'] ?? 'Anonymous'),
                  subtitle: Text(response['content'] ?? 'No content'),
                  trailing: Text(response['createdAt'] ?? ''),
                );
              },
            ),
          );
        }
      },
    );
  }
}
