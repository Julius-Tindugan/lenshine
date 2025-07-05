import 'package:flutter/material.dart';
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
    required this.onBack
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: onBack,
        ),
        title: Column(
          children: [
            Text(bookingDetails.label, style: const TextStyle(fontSize: 20, color: Colors.black)),
            Text(bookingDetails.pkg.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black)),
            const Text("DETAILS", style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: TextStyle(fontWeight: FontWeight.w800)),
                    Text("Kristine Merylle"),
                    SizedBox(height: 9),
                    Text("Phone No.", style: TextStyle(fontWeight: FontWeight.w800)),
                    Text("09381234567"),
                    SizedBox(height: 9),
                    Text("Email", style: TextStyle(fontWeight: FontWeight.w800)),
                    Text("kristinemeryllemll@gmail.com"),
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
                    Text(bookingDetails.pkg.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("Inclusions", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...bookingDetails.pkg.inclusions.map((e) => Text(e)),
                    const SizedBox(height: 10),
                    if (bookingDetails.pkg.freeItems.isNotEmpty) ...[
                      const Text("FREE", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...bookingDetails.pkg.freeItems.map((e) => Text(e)),
                    ]
                  ]),
                  _buildDivider(),
                  _buildSection(null, [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Schedule Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text("Date Placeholder")],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [const Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(bookingDetails.time)],
                        ),
                      ],
                    ),
                    if(bookingDetails.backdrop != null)...[
                      const SizedBox(height: 10),
                      const Text("Backdrop Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(bookingDetails.backdrop!),
                    ]
                  ]),
                  _buildDivider(),
                  _buildSection("Add-Ons", [
                    if(bookingDetails.addOns.isNotEmpty)
                      ...bookingDetails.addOns.map((e) => Text("• $e", style: const TextStyle(fontSize: 16)))
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
                        Text(bookingDetails.pkg.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(onPressed: onContinue, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("Continue", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            const SizedBox(height: 8),
             SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton(onPressed: onCancel, style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
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

