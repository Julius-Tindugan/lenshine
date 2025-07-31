class PackageItem {
  final int packageId;
  final String packageType;
  final String title;
  final double price;
  final String imageAsset;
  final List<String> inclusions;
  final List<String> freeItems;
  final String? description;
  final String? name;

  const PackageItem({
    required this.packageId,
    required this.packageType,
    required this.title,
    required this.price,
    required this.imageAsset,
    required this.inclusions,
    required this.freeItems,
    this.description,
    this.name,
  });

  String get formattedPrice => "PHP${price.toStringAsFixed(2)}";

  // *** FIXED fromJson FACTORY ***
  factory PackageItem.fromJson(Map<String, dynamic> json) {
    return PackageItem(
      packageId: json['package_id'],
      packageType: json['package_type'] ?? "",
      title: json['title'],
      // The price from the DB is a decimal, ensure it's a string for the UI
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      // Use the image_asset from the DB, with a fallback
      imageAsset: json['image_asset'] ?? serviceImages[json['package_type']] ?? 'assets/images/shinelogo.png',
      // Correctly parse the lists of strings from the JSON
      inclusions: List<String>.from(json['inclusions'] ?? []),
      freeItems: List<String>.from(json['freeItems'] ?? []),
      description: json['description'],
      name: json['title'],
    );
  }

  PackageItem copyWith({
    int? packageId,
    String? packageType,
    String? title,
    double? price,
    String? imageAsset,
    List<String>? inclusions,
    List<String>? freeItems,
    String? description,
    String? name,
  }) {
    return PackageItem(
      packageId: packageId ?? this.packageId,
      packageType: packageType ?? this.packageType,
      title: title ?? this.title,
      price: price ?? this.price,
      imageAsset: imageAsset ?? this.imageAsset,
      inclusions: inclusions ?? this.inclusions,
      freeItems: freeItems ?? this.freeItems,
      description: description ?? this.description,
      name: name ?? this.name,
    );
  }
}

const Map<String, String> serviceImages = {
  "Self-Shoot": "assets/images/selfshoot.png",
  "Party": "assets/images/party.png",
  "Wedding": "assets/images/wedding.png",
  "Christening": "assets/images/christening_placeholder.png",
};