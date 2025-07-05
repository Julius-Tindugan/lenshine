import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lenshine/widgets/common_text_fields.dart'; // Adjust 'your_app_name' to your project name
import 'package:lenshine/widgets/common_dialogs.dart'; // Adjust 'your_app_name' to your project name

class CreateAccountScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLoginClick;

  const CreateAccountScreen({super.key, required this.onBack, required this.onLoginClick});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool agreed = false;
  bool showSuccessDialog = false;

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      if (!agreed) {
        // Fluttertoast.showToast(msg: "You must agree to the terms");
        return;
      }
      // Simulate registration success
      setState(() {
        showSuccessDialog = true;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccessDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AccountCreatedDialog(
              onContinue: () {
                Navigator.of(context).pop();
                widget.onLoginClick();
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
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: widget.onBack,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Create Account", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
                const SizedBox(height: 8),
                const Text("Just a few quick things to create your account", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        controller: firstNameController,
                        label: "First Name",
                        icon: Icons.person,
                        validator: (value) => value!.isEmpty ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildTextField(
                        controller: lastNameController,
                        label: "Last Name",
                        icon: Icons.person,
                        validator: (value) => value!.isEmpty ? "Required" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: emailController,
                  label: "Email Address",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Required";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: phoneController,
                  label: "Phone Number",
                  prefixText: "+63",
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length < 10 ? "Invalid phone" : null,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: !passwordVisible,
                  validator: (value) => value!.length < 6 ? "Min 6 characters" : null,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => passwordVisible = !passwordVisible),
                  ),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: !confirmPasswordVisible,
                  validator: (value) => value != passwordController.text ? "Passwords do not match" : null,
                  suffixIcon: IconButton(
                    icon: Icon(confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(value: agreed, onChanged: (val) => setState(() => agreed = val!)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            const TextSpan(text: "I have agreed to the "),
                            TextSpan(
                              text: "privacy terms and conditions",
                              style: const TextStyle(color: Color(0xFF1A0DAB), decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = () { /* TODO: Open terms */ },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text("CREATE ACCOUNT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Log In",
                          style: const TextStyle(color: Color(0xFF1A0DAB), decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = widget.onLoginClick,
                        ),
                      ],
                    ),
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