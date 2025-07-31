class AddonItem {
  final int id;
  final String name;
  final double price;

  AddonItem({
    required this.id,
    required this.name,
    required this.price,
  });

  // Factory constructor to create an AddonItem from JSON.
  // This is used when fetching data from the API.
  factory AddonItem.fromJson(Map<String, dynamic> json) {
    return AddonItem(
      id: json['addon_id'],
      name: json['addon_name'],
      // The price from the DB might be a string, so parse it robustly.
      price: double.tryParse(json['addon_price'].toString()) ?? 0.0,
    );
  }

  // Method to convert an AddonItem instance to a JSON map.
  // Useful for sending data back to an API if needed.
  Map<String, dynamic> toJson() {
    return {
      'addon_id': id,
      'addon_name': name,
      'addon_price': price,
    };
  }

  // Override toString() for better debugging. Instead of "Instance of 'AddonItem'",
  // this will print out the actual details of the item.
  @override
  String toString() {
    return 'AddonItem(id: $id, name: $name, price: $price)';
  }
}
