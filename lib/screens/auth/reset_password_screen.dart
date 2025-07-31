import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final String email;
  const ResetPasswordScreen({super.key, required this.onBack, required this.onContinue, required this.email});

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
              const Text("Reset Password", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
              const SizedBox(height: 8),
              Text("A password reset link has been sent to:", style: const TextStyle(fontSize: 15)),
              Text(email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 18),
              const Text("Please check your email and follow the instructions to reset your password.", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}