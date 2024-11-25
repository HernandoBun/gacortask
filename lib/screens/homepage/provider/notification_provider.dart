import 'package:flutter/material.dart';
 
class NavigationProvider extends ChangeNotifier {
  bool _isExpanded = false;
 
  bool get isExpanded => _isExpanded;
  void toggleExpanded() {
    _isExpanded = !isExpanded;
 
    notifyListeners();
  }
  // ke main create: (context) => NavigationProvider(),
}
