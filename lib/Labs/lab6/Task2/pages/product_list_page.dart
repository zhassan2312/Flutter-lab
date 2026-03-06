import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../model/product.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  // Async function: reads products.json from assets and parses it into a list
  Future<List<Product>> fetchProducts() async {
    final String response =
        await rootBundle.loadString('assets/products.json');  // await file read
    List<dynamic> data = json.decode(response);               // decode JSON string
    return data.map((item) => Product.fromJson(item)).toList(); // map to Product objects
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalogue'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      // FutureBuilder rebuilds the widget tree as the Future resolves
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),  // kick off the async fetch
        builder: (context, snapshot) {
          // While data is loading, show a spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If the future threw an error, surface it
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Empty list guard
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          // Data ready — render a scrollable list
          else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(product.id.toString())),
                  title: Text(product.name),
                  trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
