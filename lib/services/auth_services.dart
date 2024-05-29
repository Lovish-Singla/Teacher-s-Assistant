import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> _removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  // Signing user in
  Future<User?> signin(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if(user != null){
        await _saveUserId(user.uid);
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Registering User
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await user.sendEmailVerification();
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Signing Out User
  Future<void> signout() async {
    try {
      await _auth.signOut();
      await _removeUserId();
    } catch (e) {
      print(e.toString());
    }
  }

  // Getter for user
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
