// Product model representing a single product item
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  // Factory constructor to create a Product from JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
