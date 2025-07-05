import 'package:flutter/material.dart';

class ForgotPasswordCodeScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final VoidCallback onTryAnotherWay;
  const ForgotPasswordCodeScreen({super.key, required this.onBack, required this.onContinue, required this.onTryAnotherWay});

  @override
  State<ForgotPasswordCodeScreen> createState() => _ForgotPasswordCodeScreenState();
}

class _ForgotPasswordCodeScreenState extends State<ForgotPasswordCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  void _validateAndContinue(){
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
                CircleAvatar(backgroundColor: Colors.grey[200], child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: widget.onBack)),
                const SizedBox(height: 24),
                const Text("Forgot Password", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                const SizedBox(height: 8),
                const Text("We sent your code to:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Text("k*****i@gmail.com", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                const Text("Please check your email for a message with your code. Your code is 6 numbers long.", style: TextStyle(fontSize: 13)),
                const SizedBox(height: 18),
                const Text("Enter the 6-digits code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _codeController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if (value == null || value.isEmpty) return "Code is required";
                    if (value.length != 6) return "Code must be 6 digits";
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    counterText: "",
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "######",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: _validateAndContinue, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold)))),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: widget.onTryAnotherWay, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Try another way", style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}