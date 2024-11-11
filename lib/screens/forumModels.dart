class ForumPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String type;
  final int views;
  final DateTime createdAt;
  final List<String> responseIds; // List of response IDs

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.type,
    required this.views,
    required this.createdAt,
    required this.responseIds, // Using string IDs for responses
  });

  // Factory constructor to create a ForumPost from JSON
  factory ForumPost.fromJson(Map<String, dynamic> json) {
    var responseIds = json['response'] as List;
    List<String> responseList = responseIds.map((i) => i.toString()).toList();

    return ForumPost(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      type: json['type'],
      views: json['views'],
      createdAt: DateTime.parse(json['createdAt']),
      responseIds: responseList,
    );
  }
}

class ForumResponse {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;
  final String postId;

  ForumResponse({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.postId,
  });

  // Factory constructor to create a ForumResponse from JSON
  factory ForumResponse.fromJson(Map<String, dynamic> json) {
    return ForumResponse(
      id: json['_id'],
      author: json['author'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      postId: json['postId'],
    );
  }
}