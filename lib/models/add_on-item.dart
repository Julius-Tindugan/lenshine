class AddonItem {
  final int id;
  final String name;
  final double price;

  AddonItem({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AddonItem.fromJson(Map<String, dynamic> json) {
    return AddonItem(
      id: json['addon_id'],
      name: json['addon_name'],
      // The price from the DB is a string, so parse it robustly.
      price: double.tryParse(json['addon_price'].toString()) ?? 0.0,
    );
  }
}