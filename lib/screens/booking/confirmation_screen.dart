import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lenshine/models/booking_details.dart';
import 'package:lenshine/models/add_on-item.dart';

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
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: onBack,
        ),
        title: const Text("Booking Confirmation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Please review your booking details before proceeding.", style: TextStyle(color: Colors.grey, fontSize: 15)),
            const SizedBox(height: 16),
            
            // User Info Card
            _buildInfoCard(
              title: "Customer Details",
              children: [
                _buildInfoRow("Name", firebaseUser?.displayName ?? "N/A"),
                _buildInfoRow("Phone No.", details.userProfile?['phone'] ?? firebaseUser?.phoneNumber ?? "N/A"),
                _buildInfoRow("Email", firebaseUser?.email ?? "N/A"),
              ],
            ),
            const SizedBox(height: 16),

            // Booking Details Card
            _buildInfoCard(
              title: "Booking Summary",
              children: [
                _buildInfoRow("Package", details.pkg.title),
                _buildInfoRow("Schedule", "${details.date} at ${details.time}"),
                if (details.backdrop != null)
                  _buildInfoRow("Backdrop", details.backdrop!),
              ],
            ),
            const SizedBox(height: 16),

            // Price Details Card
            _buildInfoCard(
              title: "Payment Summary",
              children: [
                _buildPriceRow("Package Price", details.pkg.price),
                const Divider(),
                // Display Add-ons with their prices
                if (details.addOns.isNotEmpty)
                  ...details.addOns.map((addon) => _buildPriceRow("  + ${addon.name}", addon.price)).toList(),
                
                _buildPriceRow("Add-ons Subtotal", details.addOnsSubtotal, isBold: true),
                const Divider(thickness: 1.5),
                _buildPriceRow("Grand Total", details.price, isTotal: true),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, double value, {bool isBold = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold || isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
          Text(
            "PHP ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold || isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 24.0),
      color: Colors.grey[50],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Continue to Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: onCancel,
              child: const Text("Cancel Booking", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
