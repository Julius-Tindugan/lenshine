import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenshine/models/package_item.dart';
import 'package:lenshine/models/booking_details.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lenshine/models/add_on-item.dart'; // Create this model file
import 'package:lenshine/services/api_service.dart';

class BookingScreen extends StatefulWidget {
  final PackageItem pkg;
  final String label;
  final VoidCallback onBack;
  final Function(BookingDetails) onBookNow;
  final int? userId;
  final Map<String, dynamic>? userProfile;

  const BookingScreen({
    super.key,
    required this.pkg,
    required this.label,
    required this.onBack,
    required this.onBookNow,
    this.userId,
    this.userProfile,
  });

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  String _selectedTime = "10:00 am";
  int _selectedBackground = 0;

  final List<String> _times = ["10:00 am", "2:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm"];
  final List<Color> _backgrounds = [
    const Color(0xFFD2B48C), const Color(0xFF87CEEB), const Color(0xFFFFB6C1), const Color(0xFFFFE4C4),
    const Color(0xFFB0FFB0), const Color(0xFFFFFF99), const Color(0xFF222222), const Color(0xFFE0E0E0)
  ];
   final List<String> _backgroundNames = [
    "Pastel Yellow", "Sky Blue", "Pink", "Beige", "Mint", "Light Yellow", "Black", "Gray"
  ];

  List<AddonItem> _addOns = [];
  late List<bool> _addOnStates;
  bool _isLoadingAddons = true;
  
 @override
  void initState() {
    super.initState();
    // REMOVE this line: _addOnStates = List.generate(_addOns.length, (index) => false);
    _fetchAddons();
  }
Future<void> _fetchAddons() async {
    try {
      final addons = await ApiService.getAddOns();
      if (mounted) {
        setState(() {
          _addOns = addons.map((data) => AddonItem.fromJson(data)).toList();
          _addOnStates = List.generate(_addOns.length, (index) => false);
          _isLoadingAddons = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAddons = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load add-ons: $e'))
        );
      }
    }
  }
  double _calculateTotal() {
    double total = widget.pkg.price;
    for (int i = 0; i < _addOns.length; i++) {
      if (_addOnStates[i]) {
        // Calculate using the price from the fetched AddonItem object
        total += _addOns[i].price;
      }
    }
    return total;
  }

 void _handleBookNow() {
  final date = DateFormat('MM/dd/yyyy').format(_selectedDate);
  final backdrop = _backgroundNames[_selectedBackground];
  
  // Create a list of the selected AddonItem objects
  final selectedAddOns = <AddonItem>[];
  for (int i = 0; i < _addOns.length; i++) {
    if (_addOnStates[i]) {
      selectedAddOns.add(_addOns[i]);
    }
  }

   final details = BookingDetails(
    pkg: widget.pkg,
    label: widget.label,
    date: date,
    time: _selectedTime,
    backdrop: backdrop,
    addOns: selectedAddOns, // Pass the clean list of objects
    price: _calculateTotal(),
    userProfile: widget.userProfile,
  );
  widget.onBookNow(details);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: widget.onBack,
        ),
        title: Column(
          children: [
            Text(widget.label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            Text(widget.pkg.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.black)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime(2101),
                  focusedDay: _focusedDate,
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Time Selection
            const Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _times.map((time) {
                final isSelected = _selectedTime == time;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedTime = time),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.black : Colors.grey[200],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(time, style: const TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            // Background Selection
            const Text("Choose your 1 preferred background", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _backgrounds.length,
              itemBuilder: (ctx, idx) {
                bool isSelected = _selectedBackground == idx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _backgrounds[idx],
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 8, offset: const Offset(0, 4))]
                        : [],
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedBackground = idx),
                  ),
                );
              },
            ),
           const SizedBox(height: 14),
    const Text("Add Ons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    const SizedBox(height: 8),
    _isLoadingAddons
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: List.generate(_addOns.length, (idx) {
              final addon = _addOns[idx];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: CheckboxListTile(
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(text: "${addon.name} - "),
                        TextSpan(
                          text: "PHP ${addon.price.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  value: _addOnStates[idx],
                  onChanged: (val) => setState(() => _addOnStates[idx] = val!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.black,
                ),
              );
            }),
          ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _handleBookNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Book Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
        ),
      ],
    );
  }
}