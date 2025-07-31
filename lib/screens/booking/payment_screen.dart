
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'; 

class PaymentScreen extends StatefulWidget {
  final String amount;
  final String gcashName; 
  final VoidCallback onBack;
  final Function(File?) onConfirm;
  
  const PaymentScreen({
    super.key,
    required this.amount,
    required this.gcashName, 
    required this.onBack,
    required this.onConfirm
  });

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  File? _proofImageFile;

  Future<void> _pickImage() async {
    // MODIFIED: Changed Permission.storage to Permission.photos
    // This is the modern, recommended permission for accessing the photo gallery.
    // It automatically falls back to storage permission on older Android versions.
    final status = await Permission.photos.request(); 

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _proofImageFile = File(pickedFile.path);
        });
      }
    } else {
      // This SnackBar is shown if permission is denied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo library permission is required to upload an image.'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: widget.onBack),
        title: const Text("GCASH PAYMENT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/qrcode.png', width: 200, height: 200),
                    const SizedBox(height: 10),
                    const Text("Scan the QR-code to pay", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("GCash Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey)),
                        Text(widget.gcashName, style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(height: 6, color: Colors.grey[200]),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Upload Payment of Proof", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickImage, // This calls the method that requests permission
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _proofImageFile != null
                                ? Image.file(_proofImageFile!, fit: BoxFit.cover)
                                : const Icon(Icons.add, color: Colors.grey, size: 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 6, color: Colors.grey[200]),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(widget.amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => widget.onConfirm(_proofImageFile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text("Confirm Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}