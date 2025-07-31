import 'package:flutter/material.dart';

class ForgotPasswordCodeScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onTryAnotherWay;
  final String email;
  const ForgotPasswordCodeScreen({super.key, required this.onBack, required this.onTryAnotherWay, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: onBack,
                ),
              ),
              const SizedBox(height: 24),
              const Text("Forgot Password", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
              const SizedBox(height: 8),
              Text("We sent a reset link to:", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(email, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              const Text("Please check your email for a password reset link. Follow the instructions in the email to reset your password.", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onTryAnotherWay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Try another way", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}