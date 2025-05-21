import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmate/list/list_controller.dart';

final billController =
    ChangeNotifierProvider<BillProvider>((ref) => BillProvider());

class BillProvider extends ChangeNotifier {
  Map<String, dynamic> _items = {};
  List<MapEntry<String, dynamic>> _billList = [];

  increment(name) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    _items = jsonDecode(jsonString);

    if (_items.containsKey(name)) {
      int currentCount =
          int.tryParse(_items[name]['count']?.toString() ?? '0') ?? 0;

      if (currentCount > 0) {
        _items[name]['count'] = currentCount - 1;
      }

      await prefs.setString('items', jsonEncode(_items));
    }
    notifyListeners();
  }

  decrement(name) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    _items = jsonDecode(jsonString);

    if (_items.containsKey(name)) {
      int currentCount =
          int.tryParse(_items[name]['count']?.toString() ?? '0') ?? 0;

      _items[name]['count'] = currentCount + 1;

      await prefs.setString('items', jsonEncode(_items));
    }
    notifyListeners();
  }

  notCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    _items = jsonDecode(jsonString);

    for (var entry in _billList) {
      String name = entry.key;
      int billCount = int.tryParse(entry.value['countt'].toString()) ?? 0;

      if (_items.containsKey(name)) {
        int currentCount = int.tryParse(_items[name]['count'].toString()) ?? 0;
        _items[name]['count'] = currentCount + billCount;
      }
      _items[name]['countt'] = 0;
    }

    await prefs.setString('items', jsonEncode(_items));

    _billList = [];
    notifyListeners();
  }

  checkout(context) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    _items = jsonDecode(jsonString);

    for (var entry in _billList) {
      String name = entry.key;
      _items[name]['countt'] = 0;
    }
      await prefs.setString('items', jsonEncode(_items));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Checkedout successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    _billList = [];
    notifyListeners();
  }

  billListAppender(String name, ref, [bool isDecrement = false]) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    _items = jsonDecode(jsonString);
    if (_items.containsKey(name)) {
      if ((_items[name]['count'] != 0 && !isDecrement) || isDecrement) {
        int currentCountt =
            int.tryParse(_items[name]['countt']?.toString() ?? '0') ?? 0;
        isDecrement
            ? _items[name]['countt'] = currentCountt > 0 ? currentCountt - 1 : 0
            : _items[name]['countt'] = currentCountt + 1;

        await prefs.setString('items', jsonEncode(_items));
        _billList = _items.entries
            .where((entry) =>
                (int.tryParse(entry.value['countt']?.toString() ?? '0') ?? 0) >
                0)
            .toList();
      }
      isDecrement ? decrement(name) : increment(name);
      await ref.read(listController).getItems();
      ref.read(listController).filter(true);
    }
    notifyListeners();
  }

  Map<String, dynamic> get items => _items;
  List<MapEntry<String, dynamic>> get billList => _billList;
}
