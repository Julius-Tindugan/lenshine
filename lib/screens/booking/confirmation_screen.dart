import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lenshine/models/booking_details.dart';

class ConfirmationScreen extends StatelessWidget {
  final BookingDetails bookingDetails;
  final VoidCallback onContinue;
  final VoidCallback onCancel;
  final VoidCallback onBack;

  const ConfirmationScreen({
    super.key,
    required this.bookingDetails,
    required this.onContinue,
    required this.onCancel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final details = bookingDetails;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: onBack,
        ),
        title: const Text("Booking Confirmation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name", style: TextStyle(fontWeight: FontWeight.w800)),
                    Text(firebaseUser?.displayName ?? "N/A"),
                    const SizedBox(height: 9),
                    const Text("Phone No.", style: TextStyle(fontWeight: FontWeight.w800)),
                    Text(details.userProfile?['phone'] ?? firebaseUser?.phoneNumber ?? "N/A"),
                    const SizedBox(height: 9),
                    const Text("Email", style: TextStyle(fontWeight: FontWeight.w800)),
                    Text(firebaseUser?.email ?? "N/A"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            // Package Info
            Card(
              shape: const RoundedRectangleBorder(),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSection("Package", [
                    Text(details.pkg.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("Inclusions", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...details.pkg.inclusions.map((e) => Text(e)),
                    const SizedBox(height: 10),
                    if (details.pkg.freeItems.isNotEmpty) ...[
                      const Text("FREE", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...details.pkg.freeItems.map((e) => Text(e)),
                    ]
                  ]),
                  _buildDivider(),
                  _buildSection(null, [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Schedule Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(details.date ?? "N/A"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(details.time),
                          ],
                        ),
                      ],
                    ),
                    if (details.backdrop != null) ...[
                      const SizedBox(height: 10),
                      const Text("Backdrop Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(details.backdrop!),
                    ]
                  ]),
                  _buildDivider(),
                  _buildSection("Add-Ons", [
                    if (details.addOns.isNotEmpty)
                      ...details.addOns.map((e) => Text("• $e", style: const TextStyle(fontSize: 16)))
                    else
                      const Text("No Add-Ons Selected", style: TextStyle(color: Colors.grey, fontSize: 16))
                  ]),
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("PHP${details.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Container(color: Colors.grey[200], height: 6);

  Widget _buildSection(String? title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          if (title != null) const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}