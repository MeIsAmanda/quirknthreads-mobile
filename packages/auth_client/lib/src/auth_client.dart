import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    smsCode,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print("signInWithEmailAndPassword");
      print(credential);
      return credential.user;

    } on FirebaseAuthMultiFactorException catch (e) {

      await FirebaseAuth.instance.verifyPhoneNumber(
        multiFactorSession: e.resolver.session,
        verificationCompleted: (_) {},
        verificationFailed: (_) {},
        codeSent: (String verificationId, int? resendToken) async {

          if (smsCode != null) {
            // Create a PhoneAuthCredential with the code
            final credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: smsCode,
            );

            try {
              await e.resolver.resolveSignIn(
                PhoneMultiFactorGenerator.getAssertion(
                  credential,
                ),
              );
            } on FirebaseAuthException catch (e) {
              print(e.message);
            }
          }
        },
        codeAutoRetrievalTimeout: (_) {},
      );

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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+65 9879 6872',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


}