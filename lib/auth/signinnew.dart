import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Sign In"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to App Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Hey you're back, fill in your details to get back in"),
            SizedBox(height: 24),
            // Phone Number Field
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+91 ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 24),
            // Social Media Login Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.apple, size: 40),
                  onPressed: () {
                    // Apple sign-in logic
                  },
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.facebook, size: 40, color: Colors.blue),
                  onPressed: () {
                    // Facebook sign-in logic
                  },
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.g_mobiledata, size: 40, color: Colors.red),
                  onPressed: () {
                    // Google sign-in logic
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to Sign Up page
                },
                child: Text(
                  "If you have an account? Sign In here",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Spacer(),
            // Send OTP Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  // OTP logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
