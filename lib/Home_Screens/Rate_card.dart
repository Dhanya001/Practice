import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInExample extends StatefulWidget {
  @override
  _GoogleSignInExampleState createState() => _GoogleSignInExampleState();
}

class _GoogleSignInExampleState extends State<GoogleSignInExample> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Successful sign-in
        print("Sign-in successful: ${account.displayName}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in successful: ${account.displayName}")),
        );
      } else {
        // User canceled the sign-in
        print("Sign-in canceled by the user.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in canceled by the user.")),
        );
      }
    } catch (error) {
      // Sign-in failed
      print("Sign-in failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithGoogle,
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
