import 'package:flutter/material.dart';

class RecipeSearchManager extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  void setQuery(String value) {
    final normalized = value.trim().toLowerCase();
    if (_query == normalized) {
      return;
    }
    _query = normalized;
    notifyListeners();
  }

  void clear() {
    if (_query.isEmpty) {
      return;
    }
    _query = '';
    notifyListeners();
  }
}