import 'package:flutter/material.dart';

class AccountCreatedDialog extends StatelessWidget {
  final VoidCallback onContinue;
  const AccountCreatedDialog({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 360,
        height: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 6),
              ),
              child: const Icon(Icons.check, color: Colors.black, size: 95),
            ),
            const SizedBox(height: 60),
            const Text(
              "Account Created\nSuccessfully !",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text("CONTINUE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginSuccessDialog extends StatelessWidget {
  final VoidCallback onContinue;
  const LoginSuccessDialog({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 320,
        height: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: const Icon(Icons.check, color: Colors.black, size: 60),
            ),
            const SizedBox(height: 60),
            const Text("LOG IN\nSUCCESSFULLY !", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text("CONTINUE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordChangedDialog extends StatelessWidget {
  final VoidCallback onContinue;
  const PasswordChangedDialog({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 320,
        height: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: const Icon(Icons.check, color: Colors.black, size: 60),
            ),
            const SizedBox(height: 60),
            const Text("Password Changed\nSuccessfully !", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text("CONTINUE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}