import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/widgets/custom_appBar.dart';
import '/widgets/custom_drawer.dart';
import 'dart:convert';

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

  String userName = 'username';
  String userEmail = 'username@example.com';
  String userPhone = '28 000 000';
  String institution = 'ESPRIT';
  String profilePictureUrl = 'assets/images/default_profile.png';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    String? token = prefs.getString('token');

    if (userData != null) {
      final parsedData = jsonDecode(userData);
      setState(() {
        userName = parsedData['name'] ?? userName;
        userEmail = parsedData['email'] ?? userEmail;
        userPhone = parsedData['phone'] ?? userPhone;
        institution = parsedData['institution'] ?? institution;
        profilePictureUrl = parsedData['profilePicture'] ?? profilePictureUrl;
      });
    }
  }

  Future<void> _saveUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final updatedUserData = jsonEncode({
      'name': userName,
      'email': userEmail,
      'phone': userPhone,
      'institution': institution,
      'profilePicture': profilePictureUrl,
    });
    await prefs.setString('user', updatedUserData);
    print('Saved changes');
  }

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
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 50,
                backgroundImage: profilePictureUrl.startsWith('http')
                    ? NetworkImage(profilePictureUrl)
                    : AssetImage(profilePictureUrl) as ImageProvider,
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
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Editable Field Builder
  Widget _buildEditableField(String title, String value, bool isEditing, VoidCallback onEditPressed) {
    return ListTile(
      leading: Icon(_getIconForTitle(title)),
      title: isEditing
          ? TextFormField(
        initialValue: value,
        onChanged: (newValue) {
          setState(() {
            if (title == 'Name') userName = newValue;
            else if (title == 'Email') userEmail = newValue;
            else if (title == 'Phone Number') userPhone = newValue;
            else if (title == 'Institution') institution = newValue;
          });
        },
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

  // Icon Selector
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
