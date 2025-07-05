import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lenshine/widgets/common_text_fields.dart'; // Adjust 'your_app_name' to your project name
import 'package:lenshine/widgets/common_dialogs.dart'; // Adjust 'your_app_name' to your project name

class LoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateAccountClick;
  final VoidCallback onForgotPasswordClick;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onBack,
    required this.onCreateAccountClick,
    required this.onForgotPasswordClick,
    required this.onLoginSuccess,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}
class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = false;
  bool rememberMe = false;
  String? loginError;
  bool showLoginSuccessDialog = false;

  void _validateAndLogin() {
    setState(() {
      loginError = null;
    });
    if (_formKey.currentState!.validate()) {
      // Simulate login
      if (emailController.text == "fail@test.com" || passwordController.text.isEmpty) {
        setState(() => loginError = "Invalid credentials. Please try again.");
      } else {
        setState(() => showLoginSuccessDialog = true);
      }
    } else {
      setState(() {
        loginError = "Please enter valid credentials.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginSuccessDialog) {
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
        setState(() => showLoginSuccessDialog = false);
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
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: widget.onBack,
                  ),
                ),
                const SizedBox(height: 24),
                const Text("So glad to see you back!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
                const SizedBox(height: 8),
                const Text("Please login to continue with your account", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 35),
                buildLoginField(
                  controller: emailController,
                  label: "Email",
                  hint: "Enter email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email required";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildLoginField(
                  controller: passwordController,
                  label: "Password",
                  hint: "Enter Password",
                  icon: Icons.lock,
                  obscureText: !passwordVisible,
                  validator: (value) => value!.isEmpty ? "Password required" : null,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => passwordVisible = !passwordVisible),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(value: rememberMe, onChanged: (val) => setState(() => rememberMe = val!)),
                    const Text("Remember Me"),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.onForgotPasswordClick,
                      child: const Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (loginError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(child: Text(loginError!, style: const TextStyle(color: Colors.red, fontSize: 14))),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text("LOG IN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Create Account",
                          style: const TextStyle(color: Color(0xFF1A0DAB), decoration: TextDecoration.underline),
                           recognizer: TapGestureRecognizer()..onTap = widget.onCreateAccountClick,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(child: Text("By logging into an account you are agreeing with our", style: TextStyle(fontSize: 14))),
                Center(
                  child: RichText(
                    text: TextSpan(
                       style: const TextStyle(color: Colors.black, fontSize: 14),
                       children: [
                         TextSpan(
                           text: "Terms and Conditions",
                           style: const TextStyle(color: Color(0xFF4EC3B5), decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () { /* TODO: Open terms */ },
                         ),
                         const TextSpan(text: " and "),
                          TextSpan(
                           text: "Privacy Statement.",
                           style: const TextStyle(color: Color(0xFF4EC3B5), decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () { /* TODO: Open privacy */ },
                         ),
                       ]
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}