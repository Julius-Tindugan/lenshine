import 'package:flutter/material.dart';


class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  const ForgotPasswordScreen({super.key, required this.onBack, required this.onContinue});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _validateAndContinue() {
    if(_formKey.currentState!.validate()){
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: widget.onBack,
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Forgot Password", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                const SizedBox(height: 12),
                const Text("Please enter your email to search for your account.", style: TextStyle(fontSize: 15)),
                const SizedBox(height: 28),
                const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email format";
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Enter your email",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}