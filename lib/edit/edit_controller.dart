import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final editController =
    ChangeNotifierProvider<editProvider>((ref) => editProvider());



class editProvider extends ChangeNotifier {
  int _totalItems = 0;

  valueUpdate(val, which) async {
    final prefs = await SharedPreferences.getInstance();
    _totalItems =  prefs.getInt('totalItems') ?? 0;
    notifyListeners();
  }

  clearValues() {
    notifyListeners();
  }

  int get totalItems => _totalItems;
  
}
