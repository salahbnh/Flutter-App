import 'package:flutter/material.dart';
import 'package:moodle_app/screens/forumHome.dart';
import '/widgets/custom_appBar.dart';
import 'examen_screen.dart';
import 'store_screen.dart';
import '/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of app bars for each screen
  final List<PreferredSizeWidget> _appBars = [
    CustomAppBar(
      title: 'Home',
      isLoggedIn: true,
      userImageUrl: 'assets/images/moodle.png',
      backgroundColor: Colors.blue[600]!,
    ),
    CustomAppBar(
      title: 'Courses',
      isLoggedIn: true,
      userImageUrl: 'assets/images/moodle.png',
      backgroundColor: Colors.blue[600]!,
    ),
    CustomAppBar(
      title: 'Forum',
      isLoggedIn: true,
      userImageUrl: 'assets/images/moodle.png',
      backgroundColor: Colors.blue[600]!,
    ),
    CustomAppBar(
      title: 'Store',
      isLoggedIn: true,
      userImageUrl: 'assets/images/moodle.png',
      backgroundColor: Colors.blue[600]!,
    ),
    CustomAppBar(
      title: 'Exams',
      isLoggedIn: true,
      userImageUrl: 'assets/images/moodle.png',
      backgroundColor: Colors.blue[600]!,
    ),
  ];

  // Define a list of widgets for each tab in BottomNavigationBar
  final List<Widget> _screens = [
    const Center(child: Text('Welcome to the Moodle App')), // Home screen content
    const Center(child: Text('Courses')),                   // Courses screen content
    ForumHome(),
    StoreScreen(),                                          // Store screen content
    ExamenScreen(),                                          // Exams screen content
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update current index based on the tapped item
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex], // Set appBar based on selected tab
      endDrawer: const CustomDrawer(),
      // Display the selected screen widget from _screens based on the selected index
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school),
            ),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications),
            ),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.store),
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.book),
            ),
            label: 'Exams',
          ),
        ],
      ),
    );
  }
}
