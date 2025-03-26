import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/network/auth/auth_network.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
          child: const Text('Twitter', style: TextStyle(color: Colors.blue)),
        ),
        SignInWithAppleButton(
          onPressed: () async {
            // final authNetwork = sl<IAuthNetwork>();
            final credential = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
              webAuthenticationOptions: WebAuthenticationOptions(
                // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                clientId: 'de.lunaone.flutter.signinwithappleexample.service',
                redirectUri:
                    // For web your redirect URI needs to be the host of the "current page",
                    // while for Android you will be using the API server that redirects back into your app via a deep link
                    // NOTE(tp): For package local development use (as described in `Development.md`)
                    // Uri.parse('https://siwa-flutter-plugin.dev/')
                    Uri.parse(
                  'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                ),
              ),
              // TODO: Remove these if you have no need for them
              // nonce: 'example-nonce',
              // state: 'example-state',
            );
            // ignore: avoid_print
            print(credential);

            // This is the endpoint that will convert an authorization code obtained
            // via Sign in with Apple into a session in your system
            final signInWithAppleEndpoint = Uri(
              scheme: 'https',
              host: 'flutter-sign-in-with-apple-example.glitch.me',
              path: '/sign_in_with_apple',
              queryParameters: <String, String>{
                'code': credential.authorizationCode,
                if (credential.givenName != null) 'firstName': credential.givenName!,
                if (credential.familyName != null) 'lastName': credential.familyName!,
                // 'useBundleId': !kIsWeb && (Platform.isIOS || Platform.isMacOS) ? 'true' : 'false',
                if (credential.state != null) 'state': credential.state!,
              },
            );
            // final session = await authNetwork.loginApple(signInWithAppleEndpoint);
          },
        ),
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
