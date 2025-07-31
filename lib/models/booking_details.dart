import 'package:lenshine/models/package_item.dart';
import 'package:lenshine/models/add_on-item.dart'; // Make sure this import exists

class BookingDetails {
  final PackageItem pkg;
  final String label;
  final String time;
  final String? backdrop;
  // --- ⬇️ MODIFIED LINES ⬇️ ---
  final List<AddonItem> addOns; // Use a single list of AddonItem objects
  // --- ⬆️ REMOVE addOnIds ⬆️ ---
  final double price;
  final Map<String, dynamic>? userProfile;
  final String? date;
  final int? bookingId;

  BookingDetails({
    required this.pkg,
    required this.label,
    required this.time,
    this.backdrop,
    required this.addOns, // The constructor now requires List<AddonItem>
    required this.price,
    this.userProfile,
    this.date,
    this.bookingId,
  });
}