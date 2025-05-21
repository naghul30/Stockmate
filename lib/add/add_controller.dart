import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmate/list/list_controller.dart';

final addController =
    ChangeNotifierProvider<AddProvider>((ref) => AddProvider());

TextEditingController _nameController = TextEditingController();
TextEditingController _countController = TextEditingController();
TextEditingController _priceController = TextEditingController();

class AddProvider extends ChangeNotifier {
  int _totalItems = 0;

  valueUpdate(val, which) async {
    final prefs = await SharedPreferences.getInstance();
    _totalItems = prefs.getInt('totalItems') ?? 0;
    notifyListeners();
  }

  addItem(context, isEdit, ref, oldName) async {
    if (_nameController.text.isEmpty ||
        _countController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return;
    }
    if (isEdit) {
      await ref.read(listController).deleteItem(oldName);
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '{}';
    final Map<String, dynamic> items = jsonDecode(jsonString);

    items[_nameController.text] = {
      'count': _countController.text,
      'price': _priceController.text,
    };

    await prefs.setString('items', jsonEncode(items));
    _nameController.clear();
    _countController.clear();
    _priceController.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isEdit ? 'Item edited successfully!' : 'Item added successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    if (isEdit) {
      await ref.read(listController).getItems();
      Navigator.pop(context);
    }

    notifyListeners();
  }

  clearValues() {
    notifyListeners();
  }

  int get totalItems => _totalItems;
  TextEditingController get nameController => _nameController;
  TextEditingController get countController => _countController;
  TextEditingController get priceController => _priceController;
}
