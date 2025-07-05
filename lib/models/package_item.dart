class PackageItem {
  final String title;
  final String price;
  final String imageAsset; // Changed from Res ID to asset path
  final List<String> inclusions;
  final List<String> freeItems;

  const PackageItem({
    required this.title,
    required this.price,
    required this.imageAsset,
    required this.inclusions,
    required this.freeItems,
  });
}