import 'package:flutter/painting.dart';

enum Importance { low, medium, high }

class GroceryItem {
  final String id;
  final String name;
  final Importance importance;
  final DateTime dueDate;
  final Color color;
  final int quantity;
  final bool isComplete;

  GroceryItem({
    required this.id,
    required this.name,
    required this.importance,
    required this.dueDate,
    required this.color,
    required this.quantity,
    this.isComplete = false,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    Importance? importance,
    DateTime? dueDate,
    Color? color,
    int? quantity,
    bool? isComplete,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      importance: importance ?? this.importance,
      dueDate: dueDate ?? this.dueDate,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
