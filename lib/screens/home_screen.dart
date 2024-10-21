import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> courses = [
    {'title': 'Course 1', 'description': 'Description of Course 1'},
    {'title': 'Course 2', 'description': 'Description of Course 2'},
    {'title': 'Course 3', 'description': 'Description of Course 3'},
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to different screens based on index
      // For example:
      // if (index == 1) Navigator.pushNamed(context, '/courses');
      // if (index == 2) Navigator.pushNamed(context, '/notifications');
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(child: Text('Welcome to the Moodle App', style: TextStyle(fontSize: 20))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/assignments');
              },
              child: const Text('View Assignments'),
            ),
            const SizedBox(height: 10), // Added spacing
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/evaluations');
              },
              child: const Text('View Evaluations'),
            ),
            const SizedBox(height: 20), // Added spacing
            ListView.builder(
              shrinkWrap: true, // Prevents ListView from taking unlimited height
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(courses[index]['title']!),
                    subtitle: Text(courses[index]['description']!),
                    onTap: () {
                      Navigator.pushNamed(context, '/course', arguments: courses[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
