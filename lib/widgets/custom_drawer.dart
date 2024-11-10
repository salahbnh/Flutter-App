import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35,
                      backgroundImage: AssetImage('assets/images/moodle.png'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UserName',
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        Row(
                          children: [
                            Text(
                              'Role',
                              style: TextStyle(color: Colors.orange[800], fontSize: 20),
                            ),
                            const SizedBox(width: 80)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Round Tables & Webinars'),
            onTap: () {
              Navigator.pushNamed(context, '/roundTablesWebinars');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book), // Icon for the exam tab
            title: const Text('Examen'), // New exam tab
            onTap: () {
              Navigator.pushNamed(context, '/examen');
            },
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
