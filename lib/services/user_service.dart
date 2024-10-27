import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/session_manager.dart';

class UserService {
  SessionManager sessionManager = new se
  static Future<void> registerUser(String username, String email, String password, String role) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'role': role,
        'institution': null,
        'profilePicture': null,
      });

      print('User registered with username and role');
    } on FirebaseAuthException catch (e) {
      print('Registration failed: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }
}
