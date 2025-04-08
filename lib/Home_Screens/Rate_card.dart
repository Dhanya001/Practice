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


import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2A4F9C),
        elevation: 0,
        title: const Text(
          'Hello, User Name!',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Container(
            color: const Color(0xFF2A4F9C),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Start typing",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Banner image
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage("assets/clinic_banner.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Popular Specialisations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                Text(
                  "Popular specialisations",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Chip(
                  label: const Text("Skin Treatment"),
                  backgroundColor: const Color(0xFF2A4F9C),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: const Text("Hair Treatments"),
                  backgroundColor: Colors.orange,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Services
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                Text(
                  "Services",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/service.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          "Service Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF2A4F9C),
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2A4F9C),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Appointment"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }
}

