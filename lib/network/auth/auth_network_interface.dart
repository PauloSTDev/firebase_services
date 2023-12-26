import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthNetwork {
  FirebaseAuth getAuth();
  Future signInWithGoogle();
}
