import 'package:flutter/material.dart'; // <-- Add this import

class TryAnotherWayScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int) onContinue; // 0=SMS, 1=Email, 2=Password
  const TryAnotherWayScreen({super.key, required this.onBack, required this.onContinue});

  @override
  State<TryAnotherWayScreen> createState() => _TryAnotherWayScreenState();
}

class _TryAnotherWayScreenState extends State<TryAnotherWayScreen> {
  int _selectedOption = 0; // Default to SMS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
              const Text(
                "Choose a way to log in",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
              const SizedBox(height: 8),
              const Text(
                "How do you want to receive the code to reset your password?",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 18),
              _buildOptionCard(
                index: 0,
                icon: Icons.phone,
                title: "Send code via SMS",
                subtitle: "09******90",
              ),
              const SizedBox(height: 8),
              _buildOptionCard(
                index: 1,
                icon: Icons.email,
                title: "Send code via Email",
                subtitle: "k*****i@gmail.com",
              ),
              const SizedBox(height: 8),
              _buildOptionCard(
                index: 2,
                icon: Icons.lock,
                title: "Enter password to login",
                subtitle: null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => widget.onContinue(_selectedOption),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    bool isSelected = _selectedOption == index;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedOption = index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (subtitle != null)
                      Text(subtitle, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Radio<int>(
                value: index,
                groupValue: _selectedOption,
                onChanged: (val) => setState(() => _selectedOption = val!),
                activeColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}