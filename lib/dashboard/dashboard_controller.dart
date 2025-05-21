import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dashboardController =
    ChangeNotifierProvider<DashboardProvider>((ref) => DashboardProvider());



class DashboardProvider extends ChangeNotifier {
  int _totalItems = 0;
  int _lowStock = 0;

  valueUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    final Map<String, dynamic> items = jsonDecode(jsonString);
    _totalItems = items.length;
    _lowStock = items.values.where((item) {
      final count = int.tryParse(item['count'].toString()) ?? 0;
      return count < 5;
    }).length;
    notifyListeners();
  }

  clearValues() {
    notifyListeners();
  }

  int get totalItems => _totalItems;
  int get lowStock => _lowStock;

  
}
