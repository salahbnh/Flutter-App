import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';
import '/widgets/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isEditingInstitution = false;

  // Static user data (can be made dynamic later)
  String userName = 'username';
  String userEmail = 'username@example.com';
  String userPhone = '28 000 000';
  String institution = 'ESPRIT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'User Profile',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png',
      ),
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // User Avatar
            const Center(
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 50,
                backgroundImage: AssetImage('assets/images/moodle.png'),
              ),
            ),
            const SizedBox(height: 16),

            // User Name
            _buildEditableField(
                'Name',
                userName,
                isEditingName,
                    () => setState(() => isEditingName = !isEditingName)
            ),

            // Role (non-editable)
            const ListTile(
              leading: Icon(Icons.badge),
              title: Text('Role'),
              subtitle: Text('Student'),  // Assuming "Student" is the role
            ),

            // Email
            _buildEditableField(
                'Email',
                userEmail,
                isEditingEmail,
                    () => setState(() => isEditingEmail = !isEditingEmail)
            ),

            // Phone Number
            _buildEditableField(
                'Phone Number',
                userPhone,
                isEditingPhone,
                    () => setState(() => isEditingPhone = !isEditingPhone)
            ),

            // Institution
            _buildEditableField(
                'Institution',
                institution,
                isEditingInstitution,
                    () => setState(() => isEditingInstitution = !isEditingInstitution)
            ),

            const SizedBox(height: 24),

            // Save Button
            Center(
              child: SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save logic (currently just printing to console)
                    print('Saved changes');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                  ),
                  child: const Text('Save Changes', style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build editable fields
  Widget _buildEditableField(String title, String value, bool isEditing, VoidCallback onEditPressed) {
    return ListTile(
      leading: Icon(_getIconForTitle(title)),
      title: isEditing
          ? TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: title,
        ),
      )
          : Text(title),
      subtitle: isEditing ? null : Text(value),
      trailing: IconButton(
        icon: Icon(isEditing ? Icons.check : Icons.edit),
        onPressed: onEditPressed,
      ),
    );
  }

  // Function to get an icon based on the title
  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Name':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Phone Number':
        return Icons.phone;
      case 'Institution':
        return Icons.school;
      default:
        return Icons.info;
    }
  }
}
