import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  IconData? icon,
  String? prefixText,
  TextInputType? keyboardType,
  bool obscureText = false,
  String? Function(String?)? validator,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(height: 4),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : (prefixText != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Text(prefixText, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ) : null),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    ],
  );
}

Widget buildLoginField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  bool obscureText = false,
  String? Function(String?)? validator,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 4),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    ],
  );
}

Widget buildPasswordField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool obscureText = false,
  String? Function(String?)? validator,
  Widget? suffixIcon,
  VoidCallback? onSuffixIconPressed,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 4),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: onSuffixIconPressed,
          ),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    ],
  );
}