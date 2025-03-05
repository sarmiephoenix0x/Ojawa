import 'package:flutter/material.dart' hide CarouselController;

class NewAccountController extends ChangeNotifier {
  bool _isLoading = false;
  int? _selectedRadioValue = 0;
  bool _useDefault = false;
  final FocusNode _accountNumberFocusNode = FocusNode();
  final FocusNode _confirmAccountNumberFocusNode = FocusNode();
  final FocusNode _ifscFocusNode = FocusNode();
  final FocusNode _accountHolderNameFocusNode = FocusNode();

  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _confirmAccountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountHolderNameController =
      TextEditingController();
  String _phoneNumber = '';

  //public getters
  bool get isLoading => _isLoading;
  String get phoneNumber => _phoneNumber;
  int? get selectedRadioValue => _selectedRadioValue;

  TextEditingController get accountNumberController => _accountNumberController;
  TextEditingController get confirmAccountNumberController =>
      _confirmAccountNumberController;
  TextEditingController get ifscController => _ifscController;
  TextEditingController get accountHolderNameController =>
      _accountHolderNameController;

  FocusNode get accountNumberFocusNode => _accountNumberFocusNode;
  FocusNode get confirmAccountNumberFocusNode => _confirmAccountNumberFocusNode;
  FocusNode get ifscFocusNode => _ifscFocusNode;
  FocusNode get accountHolderNameFocusNode => _accountHolderNameFocusNode;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }
}
