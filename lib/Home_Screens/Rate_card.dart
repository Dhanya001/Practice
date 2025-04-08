import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with logo and text
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground girl image at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20), // Adjust if needed
              child: Image.asset(
                'assets/images/girl_image.png',
                width: 250, // Set width or height as per your image
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Logo Section
            Container(
              color: const Color(0xFF2A4F9C), // Blue background
              padding: const EdgeInsets.only(top: 80, bottom: 20),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Dr. Mukesh Shah’s",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manek",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Cursive',
                    ),
                  ),
                  Text(
                    "SKIN, HAIR & LASER CLINIC",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1.5),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2A4F9C),
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: "Login"),
                  Tab(text: "Sign Up"),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                children: [
                  AuthForm(isLogin: true),
                  AuthForm(isLogin: false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Reusable form widget
class AuthForm extends StatefulWidget {
  final bool isLogin;

  const AuthForm({super.key, required this.isLogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isLogin ? "Welcome back" : "Create an account",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isLogin
                  ? "Sign in with your account"
                  : "Sign up to get started",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 25),

            // Username
            const Text("Username"),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "jonathandavis@gmail.com",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // Password
            const Text("Password"),
            const SizedBox(height: 8),
            TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "********",
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                  child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),

            // Login / Signup Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A4F9C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Add your auth logic here
                },
                child: Text(widget.isLogin ? "Login" : "Sign Up"),
              ),
            ),
            const SizedBox(height: 15),

            // Forgot password
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle reset password
                },
                child: const Text("Forgot your password? Reset here"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

