// RoundTablesWebinarsScreen.dart
import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';
import '/widgets/custom_drawer.dart';

class RoundTablesWebinarsScreen extends StatefulWidget {
  const RoundTablesWebinarsScreen({super.key});

  @override
  State<RoundTablesWebinarsScreen> createState() => _RoundTablesWebinarsScreenState();
}

class _RoundTablesWebinarsScreenState extends State<RoundTablesWebinarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Round Tables & Webinars',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png',
      ),
      endDrawer: const CustomDrawer(),
      body: const Center(
        child: Text('Explore Upcoming Webinars and Round Tables'),
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
    );
  }
}
