import 'package:flutter/material.dart';
import 'package:lenshine/models/package_item.dart';



class WeddingDetailsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(PackageItem, String) onBookNow;
  const WeddingDetailsScreen({super.key, required this.onBack, required this.onBookNow});

  @override
  WeddingDetailsScreenState createState() => WeddingDetailsScreenState();
}

class WeddingDetailsScreenState extends State<WeddingDetailsScreen> {
  PackageItem? _selectedPackage;

  @override
  Widget build(BuildContext context) {
    if (_selectedPackage != null) {
      return PackageDetailPage(
        pkg: _selectedPackage!,
        packageType: "Wedding",
        onBack: () => setState(() => _selectedPackage = null),
        onBookNow: (pkg) => widget.onBookNow(pkg, "Wedding"),
      );
    }

    return _PackageGridPage(
      pageTitle: "WEDDING",
      headerImage: 'assets/images/weddingtwo.png',
      packages: _weddingPackages,
      onBack: widget.onBack,
      onPackageSelected: (pkg) => setState(() => _selectedPackage = pkg),
    );
  }
}
const _weddingPackages = [
  PackageItem(title: "Civil Wedding", price: "PHP 5000", imageAsset: 'assets/images/civil.png', inclusions: ["Full Event Coverage", "Pre-Event Photoshoot", "200 - 300+ Soft Copies", "All Copies Enhanced Sent", "Sent Via Google Drive", "Online Gallery Posted"], freeItems: []),
  PackageItem(title: "Church Wedding", price: "PHP 7500", imageAsset: 'assets/images/church.png', inclusions: ["Full Event Coverage", "Pre-Event Photoshoot", "200 - 300+ Soft Copies", "All Copies Enhanced Sent", "Sent Via Google Drive", "Online Gallery Posted"], freeItems: []),
];

class _PackageGridPage extends StatelessWidget {
  final String pageTitle;
  final String headerImage;
  final List<PackageItem> packages;
  final VoidCallback onBack;
  final Function(PackageItem) onPackageSelected;

  const _PackageGridPage({
    required this.pageTitle,
    required this.headerImage,
    required this.packages,
    required this.onBack,
    required this.onPackageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  onPressed: onBack,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(headerImage, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pageTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Package", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1 / 1.35,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pkg = packages[index];
                  return GestureDetector(
                    onTap: () => onPackageSelected(pkg),
                   child: Card(
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min, // Add this line
    children: [
      Flexible(
        child: Image.asset(pkg.imageAsset, width: double.infinity, fit: BoxFit.cover),
      ),
      const SizedBox(height: 10), // You can reduce this if needed
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(pkg.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(pkg.price, style: const TextStyle(color: Colors.grey, fontSize: 15)),
      ),
    ],
  ),
),
                  );
                },
                childCount: packages.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
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
                  background: Image.asset(pkg.imageAsset, fit: BoxFit.cover),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
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
                      Text(pkg.price, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                      const Divider(height: 24),
                      const Text("Inclusions:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey)),
                      ...pkg.inclusions.map((item) => Text(item, style: const TextStyle(fontSize: 18))),
                      const SizedBox(height: 12),
                      if (pkg.freeItems.isNotEmpty) ...[
                        const Text("FREE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey)),
                        ...pkg.freeItems.map((item) => Text(item, style: const TextStyle(fontSize: 18))),
                      ],
                      const SizedBox(height: 120), // Space for the floating button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
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