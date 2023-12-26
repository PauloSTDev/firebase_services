import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/network/auth/auth_network_interface.dart';

class AuthNetwork implements IAuthNetwork {
  @override
  FirebaseAuth getAuth() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      FirebaseAuth auth = getAuth();
      return auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
    return await signInWithGoogle();
  }
}
