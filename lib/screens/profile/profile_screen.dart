import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  final String fullName;
  final String phoneNumber;
  final String email;

  const ProfileScreen({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () { /* TODO: Handle back, maybe via callback */ },
                  ),
                  const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(width: 48), // To balance the IconButton
                ],
              ),
            ),
            const SizedBox(height: 15),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/images/selfshoot.png'), // Placeholder
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Kristine Merylle",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  ProfileInfoCard(label: "FULL NAME", value: fullName),
                  const SizedBox(height: 12),
                  ProfileInfoCard(label: "PHONE NUMBER", value: phoneNumber),
                  const SizedBox(height: 12),
                  ProfileInfoCard(label: "EMAIL ADDRESS", value: email),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}