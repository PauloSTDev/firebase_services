import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/network/auth/auth_network.dart';
import 'package:flutter/material.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  User? user;
  final AuthNetwork authNetwork = AuthNetwork();
  final _auth = AuthNetwork().getAuthGoogle();
  String titleLogin = '';

  @override
  void initState() {
    _auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
        titleLogin = authNetwork.getTitleSocialLogin();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Social'),
          centerTitle: true,
        ),
        body: Center(
          child: user == null ? _signInButtons(authNetwork) : loggedUser(),
        ));
  }

  Widget _signInButtons(AuthNetwork authNetwork) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => authNetwork.signInWithGoogle(),
          style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
          child: const Text('Google'),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
          child: const Text('Apple', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
          onPressed: () => authNetwork.signInWithFacebook(),
          child: const Text('Facebook', style: TextStyle(color: Color.fromARGB(255, 14, 75, 187))),
        ),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey[100]),
            onPressed: () => authNetwork.signInWithTwitter(),
            child: const Text('Twitter', style: TextStyle(color: Colors.blue))),
      ],
    );
  }

  Widget loggedUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${authNetwork.getTitleSocialLogin()} Login', style: const TextStyle(color: Colors.green)),
            const Icon(Icons.check_box, color: Colors.green),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SignOut', style: TextStyle(color: Colors.red)),
            IconButton(
              onPressed: () => _auth.signOut(),
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
