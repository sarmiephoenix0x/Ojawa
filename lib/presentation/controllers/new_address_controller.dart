import 'package:flutter/material.dart';

class NewAddressController extends ChangeNotifier {
  bool _isLoading = false;
  int? _selectedRadioValue = 0;
  bool _useDefault = false;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _streetFocusNode = FocusNode();
  final FocusNode _landmarkFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _postalFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  String _phoneNumber = '';

  //public getters
  bool get isLoading => _isLoading;
  String get phoneNumber => _phoneNumber;
  int? get selectedRadioValue => _selectedRadioValue;
  bool get useDefault => _useDefault;

  TextEditingController get nameController => _nameController;
  TextEditingController get streetController => _streetController;
  TextEditingController get landmarkController => _landmarkController;
  TextEditingController get stateController => _stateController;
  TextEditingController get cityController => _cityController;
  TextEditingController get postalController => _postalController;

  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get streetFocusNode => _streetFocusNode;
  FocusNode get landmarkFocusNode => _landmarkFocusNode;
  FocusNode get stateFocusNode => _stateFocusNode;
  FocusNode get cityFocusNode => _cityFocusNode;
  FocusNode get postalFocusNode => _postalFocusNode;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setUseDefault(bool value) {
    _useDefault = value;
    notifyListeners();
  }
}
