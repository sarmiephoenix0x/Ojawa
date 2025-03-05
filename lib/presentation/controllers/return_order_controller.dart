import 'package:flutter/material.dart';

class ReturnOrderController extends ChangeNotifier {
  Map<String, bool> _isLikedMap = {};
  int _selectedRadioValue = 0;
  final TextEditingController _commentController = TextEditingController();

  //public getters
  int get selectedRadioValue => _selectedRadioValue;

  TextEditingController get commentController => _commentController;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }
}
