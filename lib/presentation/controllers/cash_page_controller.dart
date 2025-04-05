import 'package:flutter/material.dart';

class CashPageController extends ChangeNotifier {
  bool _isLoading = false;
  int? _selectedRadioValue = 0;
  TabController? _walletTab;

  TickerProvider vsync;

  CashPageController({required this.vsync}) {
    initialize();
  }

  //public getters
  bool get isLoading => _isLoading;
  int? get selectedRadioValue => _selectedRadioValue;
  TabController? get walletTab => _walletTab;

  void initialize() {
    _walletTab = TabController(length: 2, vsync: vsync);
  }
}
