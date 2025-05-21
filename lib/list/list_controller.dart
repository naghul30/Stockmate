import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final listController =
    ChangeNotifierProvider<ListProvider>((ref) => ListProvider());

TextEditingController _searchController = TextEditingController();

class ListProvider extends ChangeNotifier {
  Map<String, dynamic> _items = {};
  List<MapEntry<String, dynamic>> _filteredEntries = [];

  filter([isBill = false]) {
    if (isBill) {
      _filteredEntries = _items.entries.where((entry) {
        int countt = int.tryParse(entry.value['count'].toString()) ?? 0;
        return countt >= 1 &&
            entry.key
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      _filteredEntries = _items.entries
          .where((entry) => entry.key
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  filterLowStock() {
    _filteredEntries = _items.entries.where((entry) {
      final countStr = entry.value['count']?.toString() ?? '0';
      final count = int.tryParse(countStr) ?? 0;
      return count < 5;
    }).toList();

    notifyListeners();
  }

  sortItems(String sortBy, {bool ascending = true}) {
    _filteredEntries.sort((a, b) {
      dynamic valueA;
      dynamic valueB;

      switch (sortBy) {
        case 'name':
          valueA = a.key.toLowerCase();
          valueB = b.key.toLowerCase();
          break;
        case 'count':
          valueA = int.tryParse(a.value['count'].toString()) ?? 0;
          valueB = int.tryParse(b.value['count'].toString()) ?? 0;
          break;
        case 'price':
          valueA = int.tryParse(a.value['price'].toString()) ?? 0;
          valueB = int.tryParse(b.value['price'].toString()) ?? 0;
          break;
        default:
          return 0;
      }

      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });

    notifyListeners();
  }

  getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    _items = jsonDecode(jsonString);
    _filteredEntries = _items.entries.toList();

    notifyListeners();
  }

  deleteItem(name) async {
    final prefs = await SharedPreferences.getInstance();
    _items.remove(name);
    await prefs.setString('items', jsonEncode(_items));
    await filter();
    notifyListeners();
  }

  clearValues() {
    notifyListeners();
  }

  Map<String, dynamic> get items => _items;
  List<MapEntry<String, dynamic>> get filteredEntries => _filteredEntries;
  TextEditingController get searchController => _searchController;
}
