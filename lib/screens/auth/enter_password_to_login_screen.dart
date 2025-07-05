import 'package:flutter/material.dart';
import 'package:lenshine/widgets/common_dialogs.dart'; // Adjust 'your_app_name' to your project name

class EnterPasswordToLoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLoginSuccess;
  const EnterPasswordToLoginScreen({super.key, required this.onBack, required this.onLoginSuccess});

  @override
  State<EnterPasswordToLoginScreen> createState() => _EnterPasswordToLoginScreenState();
}

class _EnterPasswordToLoginScreenState extends State<EnterPasswordToLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool passwordVisible = false;
  bool showSuccessDialog = false;

  void _validateAndLogin(){
    if(_formKey.currentState!.validate()){
      // Simulate login success
      setState(() => showSuccessDialog = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccessDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoginSuccessDialog(
              onContinue: () {
                Navigator.of(context).pop();
                widget.onLoginSuccess();
              },
            );
          },
        );
        setState(() => showSuccessDialog = false);
      });
    }

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
                const Text("Log In", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                const Text("Please enter your password", style: TextStyle(fontSize: 15)),
                const SizedBox(height: 18),
                const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !passwordVisible,
                  validator: (value){
                    if (value == null || value.isEmpty) return "Password is required";
                    if (value.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => passwordVisible = !passwordVisible),
                    ),
                    hintText: "Enter your password",
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
                    onPressed: _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Log In", style: TextStyle(fontWeight: FontWeight.bold)),
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