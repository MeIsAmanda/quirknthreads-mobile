import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthClient{
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthClient({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;


  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<firebase_auth.User?>register({
    required String email,
    required String password,
}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return credential.user;
    } catch (err) {
      throw Exception('Failed to register: $err');
    }
  }

  Future<firebase_auth.User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return credential.user;
    } catch (err) {
      throw Exception('Failed to login: $err');
    }

  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      
    } catch (err) {
      throw Exception('Failed to logout: $err');
    }
  }
}