import 'package:flutter/material.dart';

import 'forumpage.dart';

class ForumHome extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Forum de Cours',
      'icon': Icons.forum,
      'color': Colors.blue,
      'page': ForumPage(),
    },
    {
      'title': 'Messagerie',
      'icon': Icons.message,
      'color': Colors.green,
      'page': ForumPage(),
    },
    {
      'title': 'Calendrier',
      'icon': Icons.calendar_today,
      'color': Colors.orange,
      'page': ForumPage(),
    },
    {
      'title': 'Ressources',
      'icon': Icons.book,
      'color': Colors.purple,
      'page': ForumPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return _buildMenuCard(context, menuItems[index]);
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item['page']),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'], size: 40, color: item['color']),
            ),
            SizedBox(height: 12),
            Text(
              item['title'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}