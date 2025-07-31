import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lenshine/widgets/common_dialogs.dart';
import 'package:lenshine/services/api_service.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:lenshine/widgets/terms_dialog.dart' as terms;
import 'package:lenshine/utils/terms_content.dart';

class CreateAccountScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLoginClick;
  final RecaptchaClient recaptchaClient;

  const CreateAccountScreen(
      {super.key,
      required this.onBack,
      required this.onLoginClick,
      required this.recaptchaClient});

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
  bool isSubmitting = false; // Changed from isVerifying

  // --- New reCAPTCHA state variables ---
  bool isHuman = false;
  bool isVerifying = false; // For reCAPTCHA widget loading state
  String? recaptchaError;

  // --- New reCAPTCHA verification function ---
  Future<void> _verifyRecaptcha() async {
    setState(() {
      recaptchaError = null;
      isVerifying = true;
    });
    try {
      final token =
          await widget.recaptchaClient.execute(RecaptchaAction.SIGNUP());
      if (token.isNotEmpty) {
        setState(() {
          isHuman = true;
        });
      } else {
        setState(() {
          recaptchaError = 'Verification failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        recaptchaError = 'reCAPTCHA error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  // --- Updated submission logic ---
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      // User must agree to terms and be verified as human
      if (!agreed || !isHuman) return;

      setState(() {
        isSubmitting = true;
      });

      try {
        final response = await ApiService.register(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          phone: phoneController.text,
          password: passwordController.text,
        );

        if (!mounted) return;

        if (response['success'] == true) {
          setState(() => showSuccessDialog = true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response['error'] ?? 'Registration failed')));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      } finally {
        if (mounted) {
          setState(() => isSubmitting = false);
        }
      }
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
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                      onPressed: widget.onBack,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Create Account",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
                const SizedBox(height: 8),
                const Text("Just a few quick things to create your account",
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        controller: firstNameController,
                        label: "First Name",
                        icon: Icons.person,
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildTextField(
                        controller: lastNameController,
                        label: "Last Name",
                        icon: Icons.person,
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
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
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return "Invalid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: phoneController,
                  label: "Phone Number",
                  icon: Icons.phone,
                  prefixText: "+63",
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.length < 10 ? "Invalid phone" : null,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: !passwordVisible,
                  validator: (value) =>
                      value!.length < 6 ? "Min 6 characters" : null,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => passwordVisible = !passwordVisible),
                  ),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: !confirmPasswordVisible,
                  validator: (value) =>
                      value != passwordController.text
                          ? "Passwords do not match"
                          : null,
                  suffixIcon: IconButton(
                    icon: Icon(confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => confirmPasswordVisible = !confirmPasswordVisible),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                        value: agreed,
                        onChanged: (val) => setState(() => agreed = val!)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Data Privacy and Policy",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => terms.TermsDialog(
                                      title: "Data Privacy and Policy",
                                      content: TermsContent.privacyPolicy,
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Terms of Service",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => terms.TermsDialog(
                                      title: "Terms of Service",
                                      content: TermsContent.termsOfService,
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // --- New reCAPTCHA Widget ---
                GestureDetector(
                  onTap: isVerifying || isHuman ? null : _verifyRecaptcha,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isHuman,
                              onChanged: null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              side: BorderSide(
                                  width: 2, color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text("I'm not a robot",
                                  style: TextStyle(fontSize: 18)),
                            ),
                            const Icon(Icons.autorenew,
                                color: Colors.blue, size: 32),
                          ],
                        ),
                        if (isVerifying)
                          Positioned.fill(
                            child: Container(
                              color: Colors.white.withOpacity(0.7),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (recaptchaError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(recaptchaError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14)),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: agreed && isHuman && !isSubmitting
                        ? _validateAndSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("CREATE ACCOUNT",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onLoginClick,
                      child: const Text("Log in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required FormFieldValidator<String> validator,
  TextInputType? keyboardType,
  String? prefixText,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
  );
}