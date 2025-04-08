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
