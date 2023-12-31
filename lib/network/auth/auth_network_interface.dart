import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthNetwork {
  FirebaseAuth getAuthGoogle();
  Future signInWithGoogle();
  Future<UserCredential> signInWithFacebook();
  Future<UserCredential> signInWithTwitter();
  String getTitleSocialLogin();
}
