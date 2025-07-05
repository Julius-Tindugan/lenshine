import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenshine/models/package_item.dart';
import 'package:lenshine/models/booking_details.dart';




class BookingScreen extends StatefulWidget {
  final PackageItem pkg;
  final String label;
  final VoidCallback onBack;
  final Function(BookingDetails) onBookNow;
  
  const BookingScreen({
    super.key, 
    required this.pkg, 
    required this.label, 
    required this.onBack, 
    required this.onBookNow
  });

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
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

  final List<String> _addOns = [
    "Additional Person - PHP 149", "4R Photo Print - PHP 49", "Plus 1 Backdrop - PHP 49",
    "Lighting Effect - PHP 99", "32in number Balloon - PHP 49", "5mins Extension - PHP 99",
    "Charge for Pets - PHP 149", "A4 Photo Print - PHP 100"
  ];
  late List<bool> _addOnStates;
  
  @override
  void initState() {
    super.initState();
    _addOnStates = List.generate(_addOns.length, (index) => false);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _handleBookNow(){
    final date = DateFormat('MM/dd/yyyy').format(_selectedDate);
    final backdrop = _backgroundNames[_selectedBackground];
    final selectedAddOns = <String>[];
    for (int i = 0; i < _addOns.length; i++){
      if(_addOnStates[i]){
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
            // Calendar - Simple version, replace with table_calendar for a full view
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat.yMMMM().format(_selectedDate), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ElevatedButton.icon(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Change Date'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                     Text("Selected: ${DateFormat.yMMMMd().format(_selectedDate)}", style: const TextStyle(fontSize: 16)),
                  ],
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
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 3.5, // 3 items per row
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
                return GestureDetector(
                  onTap: () => setState(() => _selectedBackground = idx),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _backgrounds[idx],
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // Add-ons
            const Text("Adds On", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ...List.generate(_addOns.length, (idx) {
              return CheckboxListTile(
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: "${_addOns[idx].split(' - ')[0]} - "),
                      TextSpan(text: _addOns[idx].split(' - ')[1], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]
                  ),
                ),
                value: _addOnStates[idx],
                onChanged: (val) => setState(() => _addOnStates[idx] = val!),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.black,
              );
            }),
             const SizedBox(height: 80), // For floating button
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