import 'package:flutter/material.dart';

class ExchangeOrderController extends ChangeNotifier {
  Map<String, bool> _isLikedMap = {};
  int? _selectedRadioValue = 0;
  int? _selectedRadioValue2 = 3;
  final TextEditingController _commentController = TextEditingController();

  //public getters
  int? get selectedRadioValue => _selectedRadioValue;
  int? get selectedRadioValue2 => _selectedRadioValue2;

  TextEditingController get commentController => _commentController;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void setSelectedRadioValue2(int value) {
    _selectedRadioValue2 = value;
    notifyListeners();
  }
}
