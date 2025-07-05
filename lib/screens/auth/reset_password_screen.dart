import 'package:flutter/material.dart';
import 'package:lenshine/widgets/common_text_fields.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/widgets/common_dialogs.dart'; // Adjust 'lenshine' to your project name

class ResetPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  const ResetPasswordScreen({super.key, required this.onBack, required this.onContinue});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool showSuccessDialog = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain one uppercase letter';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Must contain one lowercase letter';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain one number';
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return 'Must contain one special character';
    return null;
  }

  void _validateAndContinue(){
    if(_formKey.currentState!.validate()){
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
            return PasswordChangedDialog(
              onContinue: () {
                Navigator.of(context).pop();
                widget.onContinue();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(backgroundColor: Colors.grey[200], child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: widget.onBack)),
                const SizedBox(height: 24),
                const Text("Reset Password", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                const SizedBox(height: 8),
                const Text("Your password must be at least 6 characters and should include a combination of numbers, letters and special characters.", style: TextStyle(fontSize: 13)),
                const SizedBox(height: 18),
                buildPasswordField(
                  controller: _newPasswordController,
                  label: "New Password",
                  hint: "Enter new password",
                  obscureText: !newPasswordVisible,
                  validator: _validatePassword,
                  onSuffixIconPressed: () => setState(() => newPasswordVisible = !newPasswordVisible),
                ),
                const SizedBox(height: 16),
                buildPasswordField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  hint: "Confirm new password",
                  obscureText: !confirmPasswordVisible,
                  validator: (value) => value != _newPasswordController.text ? "Passwords do not match" : null,
                  onSuffixIconPressed: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold)),
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