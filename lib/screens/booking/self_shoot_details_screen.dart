import 'package:flutter/material.dart';
import 'package:lenshine/models/package_item.dart';

class SelfShootDetailsScreen extends StatefulWidget {
  final List<PackageItem> packages; // <-- Accept packages from parent
  final VoidCallback onBack;
  final Function(PackageItem, String) onBookNow;
  const SelfShootDetailsScreen({
    super.key,
    required this.packages,
    required this.onBack,
    required this.onBookNow,
  });

  @override
  SelfShootDetailsScreenState createState() => SelfShootDetailsScreenState();
}

class SelfShootDetailsScreenState extends State<SelfShootDetailsScreen> {
  PackageItem? _selectedPackage;

  @override
  Widget build(BuildContext context) {
    if (_selectedPackage != null) {
      return PackageDetailPage(
        pkg: _selectedPackage!,
        packageType: "Self-Shoot",
        onBack: () => setState(() => _selectedPackage = null),
        onBookNow: (pkg) => widget.onBookNow(pkg, "Self-Shoot"),
      );
    }

    return _PackageGridPage(
      pageTitle: "SELF-SHOOT",
      headerImage: 'assets/images/selftwo.png',
      packages: widget.packages, // <-- Use dynamic packages
      onBack: widget.onBack,
      onPackageSelected: (pkg) => setState(() => _selectedPackage = pkg),
      
    );
    
  }
}

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
  child: Image.asset(
    pkg.imageAsset,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.broken_image, size: 48)),
    ),
  ),
),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(pkg.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(pkg.formattedPrice, style: const TextStyle(color: Colors.grey, fontSize: 15)), // <-- FIXED
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
                      Text(pkg.formattedPrice, style: const TextStyle(color: Colors.grey, fontSize: 18)), // <-- FIXED
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