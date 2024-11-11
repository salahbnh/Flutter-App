import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'forum_list_page.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<ForumTopic> topics = [];

  Future<List<ForumTopic>> fetchTopics() async {
    final response =
    await http.get(Uri.parse('http://10.0.2.2:3000/api/forumpost/get'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((topic) {
          return ForumTopic(
            id: topic['_id'] ?? 'unknown',
            title: topic['title'] ?? 'No Title',
            author: topic['author'] ?? 'Unknown Author',
            type: topic['type'] ?? 'General',
            content: topic['content'] ?? 'No Content',
            views: topic['views'] ?? 0,
            response: List<String>.from(topic['response'] ?? []),
            createdAt:
            DateTime.parse(topic['createdAt'] ?? '1970-01-01T00:00:00Z'),
          );
        }).toList();
      } catch (e) {
        print('Erreur lors du décodage JSON : $e');
        throw Exception('Failed to parse topics');
      }
    } else {
      print(
          'Erreur lors de la récupération des sujets : ${response.statusCode}');
      throw Exception('Failed to load topics');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  void _loadTopics() async {
    try {
      final fetchedTopics = await fetchTopics();
      setState(() {
        topics = fetchedTopics;
      });
    } catch (e) {
      print('Error fetching topics: $e');
    }
  }

  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'cours',
    'exercice',
    'question',
    'projet'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.blue[900],
        title: Text(
          'Forum des Cours',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: TopicSearch(topics));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTopics,
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  if (_selectedCategory == 'Tous' ||
                      topics[index].type == _selectedCategory) {
                    return TopicCard(
                      topic: topics[index],
                      onTap: () => _navigateToTopicDetail(topics[index].id),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewTopic,
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_categories[index]),
              selected: _selectedCategory == _categories[index],
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = _categories[index];
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshTopics() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      topics.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _navigateToTopicDetail(String topicId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(postId: topicId),
      ),
    );
  }

  Future<void> _postNewTopic(ForumTopic topic) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/forumpost/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': topic.title,
        'author': topic.author,
        'type': topic.type,
        'content': topic.content,
        'views': topic.views,
        'createdAt': topic.createdAt.toIso8601String(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create topic');
    }
  }

  void _addNewTopic() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String content = '';
        String category = 'cours';

        return AlertDialog(
          title: Text('Nouveau sujet'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Titre'),
                  onChanged: (value) => title = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(hintText: 'Contenu'),
                  maxLines: 3,
                  onChanged: (value) => content = value,
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: category,
                  items:
                  _categories.where((c) => c != 'Tous').map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      category = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Publier'),
              onPressed: () async {
                if (title.isNotEmpty && content.isNotEmpty) {
                  try {
                    final newTopic = ForumTopic(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      author: 'Utilisateur actuel', // Auteur par défaut
                      type: category,
                      content: content,
                      response: [],
                      views: 0,
                      createdAt: DateTime.now(),
                    );

                    await _postNewTopic(newTopic);

                    setState(() {
                      topics.add(newTopic);
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error posting topic: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                          Text('Erreur lors de la publication du sujet')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class TopicCard extends StatelessWidget {
  final ForumTopic topic;
  final VoidCallback onTap;

  const TopicCard({Key? key, required this.topic, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
              children: [
              _buildCategoryChip(),
          Spacer(),
          ],
        ),
        SizedBox(height: 20),
          Text(
            topic.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Par ${topic.author}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height:20),
            Row(
              children: [
                _buildInfoChip(
                    Icons.message, '${topic.response.length} réponses'),
                SizedBox(width: 12),
                _buildInfoChip(Icons.remove_red_eye, '${topic.views} vues'),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Chip(
      label: Text(
        topic.type,
        style: TextStyle(fontSize: 12),
      ),
      backgroundColor: _getCategoryColor(topic.type),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      label: Row(
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 4),
          Text(label),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'cours':
        return Colors.blue;
      case 'exercice':
        return Colors.green;
      case 'question':
        return Colors.orange;
      case 'projet':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class ForumTopic {
  final String id;
  final String title;
  final String author;
  final String type;
  final String content;
  final int views;
  final List<String> response;
  final DateTime createdAt;

  ForumTopic({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.content,
    required this.views,
    required this.response,
    required this.createdAt,
  });
}

// class TopicDetailPage extends StatelessWidget {
//   final String topicId;

//   TopicDetailPage({required this.topicId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Détails du sujet')),
//       body: Center(child: Text('Page de détails pour le sujet $topicId')),
//     );
//   }
// }

class TopicSearch extends SearchDelegate {
  final List<ForumTopic> topics;

  TopicSearch(this.topics);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = topics
        .where((topic) =>
    topic.title.toLowerCase().contains(query.toLowerCase()) ||
        topic.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          subtitle: Text(results[index].author),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/postDetail', // Named route
              arguments: results[index].id, // Pass the postId as an argument
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = topics
        .where((topic) =>
    topic.title.toLowerCase().contains(query.toLowerCase()) ||
        topic.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].title),
          subtitle: Text(suggestions[index].author),
          onTap: () {
            query = suggestions[index].title;
            showResults(context);
          },
        );
      },
    );
  }
}