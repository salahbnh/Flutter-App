import 'package:flutter/material.dart';
import 'package:moodle_app/screens/addwebinars_screen.dart';
import '/widgets/custom_appBar.dart';
import '/widgets/custom_drawer.dart';

class Webinar {
  final String title;
  final String description;
  final DateTime date;
  final int duration;
  final int maxParticipants;

  Webinar({
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.maxParticipants,
  });
}

class RoundTablesWebinarsScreen extends StatefulWidget {
  const RoundTablesWebinarsScreen({super.key});

  @override
  State<RoundTablesWebinarsScreen> createState() => _RoundTablesWebinarsScreenState();
}

class _RoundTablesWebinarsScreenState extends State<RoundTablesWebinarsScreen> {
  final List<Webinar> webinars = [
    Webinar(
      title: 'Flutter Basics',
      description: 'Learn the fundamentals of Flutter and how to build apps.',
      date: DateTime.now().add(Duration(days: 1)),
      duration: 60,
      maxParticipants: 100,
    ),
    Webinar(
      title: 'Dart for Beginners',
      description: 'An introduction to Dart programming language.',
      date: DateTime.now().add(Duration(days: 2)),
      duration: 45,
      maxParticipants: 50,
    ),
    Webinar(
      title: 'Advanced Flutter Techniques',
      description: 'Explore advanced features in Flutter for building complex apps.',
      date: DateTime.now().add(Duration(days: 3)),
      duration: 90,
      maxParticipants: 75,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Round Tables & Webinars',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png',
      ),
      endDrawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: webinars.length,
        itemBuilder: (context, index) {
          final webinar = webinars[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.video_call), // Icon for the webinar
              title: Text(webinar.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(webinar.description),
                  const SizedBox(height: 4.0),
                  Text('Date: ${webinar.date}'),
                  Text('Duration: ${webinar.duration} min'),
                  Text('Max Participants: ${webinar.maxParticipants}'),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Webinars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Participants',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateWebinarMenu(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateWebinarMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 700, 0, 0), // Adjust position as needed
      items: [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddWebinarScreen()), // Navigate to the AddWebinarScreen
              );
            },
            child: const Text('Create New Webinar'),
          ),
        ),
      ],
    );
  }

  void _createNewWebinar() {
    // Logic for creating a new webinar
    // You might want to navigate to another screen or show a dialog
    print('Create New Webinar button pressed');
  }
}
