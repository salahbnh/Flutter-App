import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';
import 'courses_screen.dart'; // Import the CoursesScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index

  final List<Widget> _screens = const [
    Center(child: Text('Welcome to the Moodle App')), // Placeholder for Home
    CoursesScreen(), // Add CoursesScreen here
    Center(child: Text('Notifications')), // Placeholder for Notifications
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png',
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: const Text('User Name', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const ListTile(
              title: Text('Profile'),
            ),
            const ListTile(
              title: Text('Settings'),
            ),
            // Add more options here
          ],
        ),
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the selected index
        onTap: _onItemTapped, // Handle tap
      ),
    );
  }
}
