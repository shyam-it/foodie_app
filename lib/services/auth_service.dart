import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current logged-in user
  User? get currentUser => _auth.currentUser;

  // Listen to login/logout changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Signup
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Login
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
