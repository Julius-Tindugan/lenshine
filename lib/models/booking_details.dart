import 'package:lenshine/models/package_item.dart';
import 'package:lenshine/models/add_on-item.dart';

class BookingDetails {
  final PackageItem pkg;
  final String label;
  final String time;
  final String? backdrop;
  final List<AddonItem> addOns; // Uses a list of the full AddonItem objects
  final double price; // This is the final total price (package + addons)
  final Map<String, dynamic>? userProfile;
  final String? date;
  final int? bookingId;

  BookingDetails({
    required this.pkg,
    required this.label,
    required this.time,
    this.backdrop,
    required this.addOns,
    required this.price,
    this.userProfile,
    this.date,
    this.bookingId,
  });

  // A getter to easily calculate the subtotal of just the add-ons.
  double get addOnsSubtotal {
    // The 'fold' method is a clean way to sum up values in a list.
    // It starts with an initial value of 0.0 and adds the price of each addon.
    return addOns.fold(0.0, (sum, item) => sum + item.price);
  }
}
