
import 'package:lenshine/models/package_item.dart';

class BookingDetails {
  final PackageItem pkg;
  final String date;
  final String time;
  final String? backdrop;
  final List<String> addOns;
  final String label;

  BookingDetails({
    required this.pkg,
    required this.date,
    required this.time,
    this.backdrop,
    this.addOns = const [],
    required this.label,
  });
}