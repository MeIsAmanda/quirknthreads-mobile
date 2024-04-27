import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:db_client/db_client.dart';
import 'package:auth_client/auth_client.dart';

class AuthRepository {
  final AuthClient authClient;
  final DbClient dbClient;

  AuthRepository({
    required this.authClient,
    required this.dbClient,
});

  Stream<firebase_auth.User?> get authStateChanges => authClient.authStateChanges;

  firebase_auth.User? get currentUser => authClient.currentUser;


  Future<bool> register({
    required String email,
    required String password,
}) async {
    print("Inside here");
    final user = await authClient.register(email: email, password: password);
    print("Inside here 2");
    if (user == null) {
      return false;
    }
    print("Inside here 3");
    // Set default roles to "customer"
    final userData = {
      'email': email,
      'joinDate': Timestamp.now(),
      'name': email.split('@')[0], // Use email username as default name
      'roles': ['customer'],
      'uid': user.uid,
    };

    await dbClient.set(
      collection: 'users',
      documentId: user.uid,
      data: userData,
    );

    // Send email verification
    await user.sendEmailVerification();

    return true;

  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final user = await authClient.login(email: email, password: password);

    if (user == null) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    await authClient.logout();
  }

  Future<bool> isEmailVerified() async {
    final currentUser = await authClient.currentUser;
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }
}