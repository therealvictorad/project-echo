import 'package:flutter/material.dart';
import 'dart:async';

import 'main_screen.dart';

/// Splash screen for Project Echo
/// Displays app logo with fade-in before navigating to MainScreen.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Fade-in effect
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _opacity = 1.0);
    });

    // Navigation after delay
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          curve: Curves.easeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/echo_logo.png',
                width: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Project Echo",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
