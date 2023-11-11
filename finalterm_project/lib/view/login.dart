import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Sign in with Google'),
              onPressed: () async {
                final UserCredential userCredential = await signInWithGoogle();
                UserRepository.login(UserModel.fromCredential(userCredential));
                await Provider.of<ProductRepository>(context, listen: false).loadAllFromDatabase();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ElevatedButton(
              child: const Text('Sign in Anonymously'),
              onPressed: () async {
                final UserCredential userCredential = await signInAnonymously();
                UserRepository.login(UserModel.fromCredential(userCredential));
                await Provider.of<ProductRepository>(context, listen: false).loadAllFromDatabase();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
