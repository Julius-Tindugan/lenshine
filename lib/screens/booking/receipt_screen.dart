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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset('assets/images/success.png', height: 150),
              const SizedBox(height: 16),
              const Text(
                "Payment In Progress", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
              ),
              const SizedBox(height: 8),
              const Text(
                "Your booking is confirmed. We will verify your payment shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 24),
              
              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Booking For", firebaseUser?.displayName ?? "N/A"),
                    _buildInfoRow("Package", bookingDetails.pkg.title),
                    _buildInfoRow("Schedule", "${bookingDetails.date} at ${bookingDetails.time}"),
                    if(bookingDetails.backdrop != null)
                      _buildInfoRow("Backdrop", bookingDetails.backdrop!),
                    
                    const Divider(height: 24),

                    // Price Breakdown
                    _buildPriceRow("Package Price", bookingDetails.pkg.price),
                    if (bookingDetails.addOns.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text("Add-Ons:", style: TextStyle(color: Colors.grey)),
                      ...bookingDetails.addOns.map((addon) => _buildPriceRow("  + ${addon.name}", addon.price)).toList(),
                    ],
                    const Divider(height: 16),
                    _buildPriceRow("Total Paid", bookingDetails.price, isTotal: true),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              const Text(
                "Please take a screenshot of this receipt for your records. Present it to our staff upon arrival.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onBackToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Back to Home", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
          Text(
            "PHP ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.black : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
