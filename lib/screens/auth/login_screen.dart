import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lenshine/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lenshine/widgets/terms_dialog.dart' as terms;

class LoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateAccountClick;
  final VoidCallback onForgotPasswordClick;
  final Function(int) onLoginSuccess;
  final RecaptchaClient recaptchaClient;

  const LoginScreen({
    super.key,
    required this.onBack,
    required this.onCreateAccountClick,
    required this.onForgotPasswordClick,
    required this.onLoginSuccess,
    required this.recaptchaClient,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = false;
  String? loginError;
  bool isLoading = false;
  bool isHuman = false;
  bool isVerifying = false;
  String? recaptchaError;
  bool agreedToTerms = false;

  Future<void> _validateAndLogin() async {
    setState(() {
      loginError = null;
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        // 1. Try Firebase login
        UserCredential? firebaseUser;
        try {
          firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
        } catch (e) {
          setState(() {
            loginError = "Firebase login failed: ${e.toString()}";
            isLoading = false;
          });
          return;
        }

        // 2. Sync password to backend
        final syncRes = await ApiService.updatePassword(
          email: emailController.text.trim(),
          newPassword: passwordController.text,
        );
        if (syncRes['success'] != true) {
          setState(() {
            loginError = "Password sync failed: ${syncRes['error'] ?? 'Unknown error'}";
            isLoading = false;
          });
          return;
        }

        // 3. Backend login
        final response = await ApiService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        if (response['success'] == true && response['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', response['user']['user_id'].toString());
          widget.onLoginSuccess(response['user']['user_id']);
        } else {
          setState(() {
            loginError = response['error'] ?? 'Invalid credentials';
          });
        }
      } catch (e) {
        setState(() {
          loginError = 'Network error. Please try again.';
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _verifyRecaptcha() async {
    setState(() {
      recaptchaError = null;
      isVerifying = true;
    });
    try {
      final token = await widget.recaptchaClient.execute(RecaptchaAction.LOGIN());
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
      setState(() {
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms and Conditions",
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => terms.TermsDialog(
                                      title: "Terms and Conditions",
                                      content: '''By accessing or using the LenShine mobile application ("App"), you acknowledge and agree to be bound by these Terms and Conditions. Your use of the App constitutes acceptance of these terms. If you do not agree with any part of these terms, please refrain from using the App.

**I. SCOPE OF TERMS**
• User registration and account management
• Booking processes and payment systems
• Client-studio interactions
• Services administered by Shine Spot Studio

**II. USER ACCOUNTS AND SECURITY**

**A. Registration Requirements**
• Users must provide accurate and complete personal information.
• Required details include full name, valid email, and contact information.
• Submission of false information may result in immediate account termination.

**B. Account Security**
• Users bear full responsibility for password confidentiality.
• Immediate notification required for any unauthorized access.
• Regular security updates and password changes recommended.

**C. Account Termination**
• The Studio reserves the right to suspend or terminate accounts for fraudulent activities, harassment, misconduct, violation of terms, or an extended period of inactivity.

**III. SERVICES AND BOOKING POLICIES**

**A. Booking Process**
• Digital booking system for photography sessions.
• Package selection and customization options.
• Flexible scheduling and rescheduling capabilities.
• Real-time availability updates.

**B. Payment Terms**
• **Accepted Methods:** GCash (Primary) and Cash (On-site).
• **Security:** TLS 1.2+ encryption for all transactions and secure payment gateway integration.
• **Disclaimer:** Not liable for third-party service disruptions.

**C. Cancellation Policy**
• **Full Refund:** Cancellations made 24+ hours before the session.
• **No Refund:** Late cancellations with less than 24 hours notice.
• Force majeure considerations may apply.

**IV. INTELLECTUAL PROPERTY RIGHTS**

**A. User Content**
• Users retain ownership of uploaded content (e.g., photos/media).
• A limited license is granted to Shine Spot Studio for editing, content delivery, and service fulfillment.

**B. Application Rights**
• **Ownership:** Batangas State University and Shine Spot Studio retain all proprietary rights to the App.
• **Protected Elements:** Includes source code, visual design, and branding assets.

**V. LIABILITY AND LIMITATIONS**

**A. Service Limitations**
The App explicitly disclaims liability for:
• **Technical Issues:** Booking system conflicts, notification delivery failures, platform downtime.
• **Service Disputes:** Photography quality concerns, session-related disagreements.

**B. Data Responsibility**
• Users must maintain personal backups of their media.
• The studio is not liable for data loss, media corruption, or transfer failures.

**VI. ACCOUNT TERMINATION**

**A. Termination Grounds**
• Violation of terms and conditions.
• Account inactivity exceeding 12 months.
• Fraudulent activities.

**B. Termination Process**
• Written notification via email.
• A grace period may be provided for data retrieval.
• Account deactivation procedures will follow.

**VII. GOVERNING LAW**

**A. Jurisdiction**
• Governed by Philippine Law, with specific compliance with the Data Privacy Act of 2012 (RA 10173).

**B. Dispute Resolution**
• **Venue:** Batangas Courts.
• Mediation options are available.

**VIII. AMENDMENTS AND UPDATES**

**A. Policy Changes**
• Terms are subject to periodic review and updates.
• Users will be notified of changes.
• Continuation of use implies acceptance of the updated terms.

**B. Version Control**
• Changes will be documented, and previous versions may be accessible.
''',
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
                GestureDetector(
                  onTap: isVerifying || isHuman ? null : _verifyRecaptcha,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              side: BorderSide(width: 2, color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text("I'm not a robot", style: TextStyle(fontSize: 18)),
                            ),
                            const Icon(Icons.autorenew, color: Colors.blue, size: 32),
                          ],
                        ),
                        if (isVerifying)
                          Positioned.fill(
                            child: Container(
                              color: Colors.white.withOpacity(0.7),
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: widget.onForgotPasswordClick,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://policies.google.com/privacy')),
                      child: const Text('Privacy', style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline)),
                    ),
                    const Text(' - ', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://policies.google.com/terms')),
                      child: const Text('Terms', style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                if (recaptchaError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(recaptchaError!, style: const TextStyle(color: Colors.red, fontSize: 14)),
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
                    onPressed: isLoading || !isHuman || !agreedToTerms ? null : _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOG IN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onCreateAccountClick,
                      child: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// You need to define buildLoginField, if it is not in this file.
// Assuming it is in 'package:lenshine/widgets/common_text_fields.dart'
Widget buildLoginField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  required FormFieldValidator<String> validator,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    obscureText: obscureText,
    validator: validator,
  );
}