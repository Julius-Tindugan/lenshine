import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  final String? userName; // <-- Add this

  const LandingScreen({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/shinelogo.png',
              width: 250,
              height: 150,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              color: Colors.black,
            ),
            if (userName != null) ...[
              const SizedBox(height: 16),
              Text("Welcome, $userName!", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }
}