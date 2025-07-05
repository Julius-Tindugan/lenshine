import 'package:flutter/material.dart';

class AfterLandingScreen extends StatelessWidget {
  final VoidCallback onCreateAccountClick;
  final VoidCallback onLoginClick;

  const AfterLandingScreen({
    super.key,
    required this.onCreateAccountClick,
    required this.onLoginClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shinelogo.png',
            width: 250,
            height: 150,
          ),
          const SizedBox(height: 2),
          const Text(
            "CLICKING WITH LOVE FOR PHOTOGRAPHY",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Archivo', // Use Archivo Bold font
            ),
          ),
          const SizedBox(height: 250),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onLoginClick,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text("LOG IN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onCreateAccountClick,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text("CREATE ACCOUNT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}