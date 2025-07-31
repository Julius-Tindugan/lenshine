import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lenshine/models/booking_details.dart';

class ReceiptScreen extends StatelessWidget {
  final VoidCallback onBackToHome;
  final BookingDetails bookingDetails;
  
  const ReceiptScreen({
    super.key, 
    required this.onBackToHome,
    required this.bookingDetails
  });

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/images/success.png', height: 200),
              const SizedBox(height: 2),
              const Text("Payment In Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 30),
              
              _buildInfoSection(
                title: "Name",
                value: firebaseUser?.displayName ?? "N/A",
              ),
              _buildInfoSection(
                title: "Phone No.",
                value: bookingDetails.userProfile?['phone'] ?? firebaseUser?.phoneNumber ?? "N/A",
              ),
              _buildInfoSection(
                title: "Email",
                value: firebaseUser?.email ?? "N/A",
              ),

              const Divider(height: 24),

              Text(bookingDetails.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              _buildBookingRow("Package", bookingDetails.pkg.title),
              _buildBookingRow("Schedule Date", bookingDetails.date ?? "N/A"),
              _buildBookingRow("Time", bookingDetails.time),
              if(bookingDetails.backdrop != null)
                _buildBookingRow("Backdrop Color", bookingDetails.backdrop!),

              if(bookingDetails.addOns.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Add-Ons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bookingDetails.addOns.map((e) => Text("• $e", style: const TextStyle(fontSize: 15))).toList(),
                  ),
                )
              ] else ... [
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Add-Ons: None", style: TextStyle(color: Colors.grey, fontSize: 15))
                )
              ],
              
              const Divider(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("PHP${bookingDetails.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Take a screenshot of this and present it to the staff during your appointment.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onBackToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Back to home", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String value}){
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBookingRow(String title, String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(value)],
    );
  }
}