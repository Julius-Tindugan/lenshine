import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenshine/models/package_item.dart';
import 'package:lenshine/models/booking_details.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lenshine/models/add_on-item.dart';
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
    _fetchAddons();
  }

  Future<void> _fetchAddons() async {
    try {
      final addonsJson = await ApiService.getAddOns();
      if (mounted) {
        setState(() {
          _addOns = addonsJson.map((data) => AddonItem.fromJson(data)).toList();
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

  double _calculateAddonsSubtotal() {
    double subtotal = 0;
    for (int i = 0; i < _addOns.length; i++) {
      if (_addOnStates[i]) {
        subtotal += _addOns[i].price;
      }
    }
    return subtotal;
  }

  double _calculateGrandTotal() {
    return widget.pkg.price + _calculateAddonsSubtotal();
  }

  void _handleBookNow() {
    final date = DateFormat('MM/dd/yyyy').format(_selectedDate);
    final backdrop = _backgroundNames[_selectedBackground];
    
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
      addOns: selectedAddOns,
      price: _calculateGrandTotal(),
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
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0), // Add padding for footer
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Select Date"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle("Select Time"),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _times.map((time) {
                final isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedTime = time);
                    }
                  },
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Choose your 1 preferred background"),
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
                return GestureDetector(
                  onTap: () => setState(() => _selectedBackground = idx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: _backgrounds[idx],
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected ? Border.all(color: Colors.black, width: 3) : Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Add Ons"),
            _isLoadingAddons
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: Column(
                    children: [
                      ...List.generate(_addOns.length, (idx) {
                        final addon = _addOns[idx];
                        return CheckboxListTile(
                          title: Text(addon.name),
                          subtitle: Text("PHP ${addon.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey)),
                          value: _addOnStates[idx],
                          onChanged: (val) => setState(() => _addOnStates[idx] = val!),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.black,
                        );
                      }),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Add-ons Subtotal", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("PHP ${_calculateAddonsSubtotal().toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "PHP ${_calculateGrandTotal().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}
