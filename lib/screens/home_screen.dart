import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';
import '/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png',
      ),
      endDrawer: const CustomDrawer(),
      body: const Center(
        child: Text('Welcome to the Moodle App'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to other screens when tapping
          if (index == 1) {
            // Navigate to the 'Courses' screen
            Navigator.pushNamed(context, '/courses');
          }
        },
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
      ),
    );
  }


  Widget _getSelectedPage(int index) {
    switch (index) {
      case 1:
        return const Center(child: Text('Courses Page')); // Default course page placeholder
      case 2:
        return const Center(child: Text('Notifications Page'));
      default:
        return const Center(child: Text('Welcome to the Moodle App'));
    }
  }
}
