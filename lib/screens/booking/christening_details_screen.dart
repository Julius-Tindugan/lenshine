import 'package:flutter/material.dart';
import 'package:lenshine/models/package_item.dart';


class ChristeningDetails extends StatelessWidget {
  final PackageItem pkg;
  final VoidCallback onBack;
  final Function(PackageItem, String) onBookNow;

  const ChristeningDetails({
    super.key,
    required this.pkg,
    required this.onBack,
    required this.onBookNow,
    // REMOVE packageType from here if present
  });


@override
  Widget build(BuildContext context) {
    return PackageDetailPage(
      pkg: pkg,
      packageType: "Christening", // <-- always provided here
      onBack: onBack,
      onBookNow: (p) => onBookNow(p, "Christening"),
    );
  }
}

class PackageDetailPage extends StatelessWidget {
  final PackageItem pkg;
  final String packageType;
  final VoidCallback onBack;
  final Function(PackageItem) onBookNow;

  const PackageDetailPage({
    super.key,
    required this.pkg,
    required this.packageType,
    required this.onBack,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 470,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: onBack,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: pkg.imageAsset,
                    child: Image.asset(pkg.imageAsset, fit: BoxFit.cover),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                        child: Text("$packageType Package", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(pkg.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                      Text(pkg.formattedPrice, style: const TextStyle(color: Colors.grey, fontSize: 18)), // <-- FIXED
                      const Divider(height: 24),
                      const Text("Inclusions:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey)),
                      ...pkg.inclusions.map((item) => Text(item, style: const TextStyle(fontSize: 18))),
                      const SizedBox(height: 12),
                      if (pkg.freeItems.isNotEmpty) ...[
                        const Text("FREE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey)),
                        ...pkg.freeItems.map((item) => Text(item, style: const TextStyle(fontSize: 18))),
                      ],
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => onBookNow(pkg),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                  ),
                  child: const Text("Book Now", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}