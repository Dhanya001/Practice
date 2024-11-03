import 'package:flutter/material.dart';
import 'dart:convert';  // For jsonEncode
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('https://{hostname}/api/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Success response
        final responseData = jsonDecode(response.body);
        print('Login Successful: $responseData');
        // You can show a success message or navigate to another screen
      } else {
        // Error response
        print('Error: ${response.statusCode}');
        // Handle error response like invalid credentials
      }
    } catch (e) {
      // Handle any other exceptions
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              login();
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
