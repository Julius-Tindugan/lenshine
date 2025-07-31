import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lenshine/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final profileData = await ApiService.getProfile(int.tryParse(userId) ?? 0);
      setState(() {
        userProfile = profileData['profile'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/shinelogo.png'),
                        fit: BoxFit.cover,
                        opacity: 0.18,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                        
                      ],
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: const AssetImage('assets/images/selfshoot.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Text(
                user?.displayName ?? userProfile?['first_name'] ?? "No Name",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: 0.2),
              ),
              const SizedBox(height: 6),
              Text(
                userProfile?['email'] ?? user?.email ?? "",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    ProfileInfoCard(label: "FULL NAME", value: user?.displayName ?? userProfile?['first_name'] ?? ""),
                    const SizedBox(height: 12),
                    ProfileInfoCard(label: "EMAIL ADDRESS", value: user?.email ?? userProfile?['email'] ?? ""),
                    const SizedBox(height: 12),
                    ProfileInfoCard(
                      label: "PHONE NUMBER",
                      value: userProfile?['phone'] ?? user?.phoneNumber ?? "N/A",
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}