import 'package:flutter/material.dart';

class PaymentMethodController extends ChangeNotifier {
  bool _isCreditCardExpanded = false;
  bool _isNetBankingExpanded = false;
  bool _isWalletExpanded = false;
  int _selectedPaymentMethod = 0;
  String _buttonText = "Continue";

  //public getters
  bool get isCreditCardExpanded => _isCreditCardExpanded;
  int get selectedPaymentMethod => _selectedPaymentMethod;
  String get buttonText => _buttonText;
  bool get isNetBankingExpanded => _isNetBankingExpanded;
  bool get isWalletExpanded => _isWalletExpanded;

  void setIsCreditCardExpanded(bool value) {
    _isCreditCardExpanded = value;
    notifyListeners();
  }

  void setSelectedPaymentMethod(int value) {
    _selectedPaymentMethod = value;
    notifyListeners();
  }

  void setButtonText(String value) {
    _buttonText = value;
    notifyListeners();
  }

  void setIsNetBankingExpanded(bool value) {
    _isNetBankingExpanded = value;
    notifyListeners();
  }

  void setIsWalletExpanded(bool value) {
    _isWalletExpanded = value;
    notifyListeners();
  }
}
