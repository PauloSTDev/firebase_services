import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/network/auth/auth_network_interface.dart';
import 'package:firebase_services/network/keys/authentication_keys.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';

enum TitleLogin { google, facebook, apple, twitter, none }

class AuthNetwork implements IAuthNetwork {
  TitleLogin titleLogin = TitleLogin.none;

  @override
  FirebaseAuth getAuthGoogle() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      FirebaseAuth auth = getAuthGoogle();
      titleLogin = TitleLogin.google;
      return auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
    return await signInWithGoogle();
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    late OAuthCredential facebookAuthCredential;

    // Create a credential from the access token
    if (loginResult.accessToken?.token == null) {
    } else {
      facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      titleLogin = TitleLogin.facebook;
    }

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  Future<UserCredential> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final twitterLogin = TwitterLogin(
      apiKey: twitterApiKey,
      apiSecretKey: twitterApiSecretKey,
      redirectURI: twitterRedirectURI,
    );

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );
    titleLogin = TitleLogin.twitter;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  }

  @override
  String getTitleSocialLogin() {
    switch (titleLogin) {
      case TitleLogin.facebook:
        return 'Facebook';
      case TitleLogin.apple:
        return 'Apple';
      case TitleLogin.google:
        return 'Google';
      case TitleLogin.twitter:
        return 'Twitter';
      default:
        return 'Not Logged';
    }
  }
}
