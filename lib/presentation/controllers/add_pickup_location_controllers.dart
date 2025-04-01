import 'package:flutter/material.dart';

class AddPickupLocationControllers extends ChangeNotifier {
  bool _isLoading = false;
  int? _selectedRadioValue = 0;
  String _phoneNumber = '';

  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _additionalAddressController =
      TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  final FocusNode _pickupLocationFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _pinCodeFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _additionalAddressFocusNode = FocusNode();
  final FocusNode _longitudeFocusNode = FocusNode();
  final FocusNode _latitudeFocusNode = FocusNode();

  //public getters
  bool get isLoading => _isLoading;
  int? get selectedRadioValue => _selectedRadioValue;
  String? get phoneNumber => _phoneNumber;

  TextEditingController get pickupLocationController =>
      _pickupLocationController;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get cityController => _cityController;
  TextEditingController get stateController => _stateController;
  TextEditingController get countryController => _countryController;
  TextEditingController get pinCodeController => _pinCodeController;
  TextEditingController get addressController => _addressController;
  TextEditingController get additionalAddressController =>
      _additionalAddressController;
  TextEditingController get longitudeController => _longitudeController;
  TextEditingController get latitudeController => _latitudeController;

  FocusNode get pickupLocationFocusNode => _pickupLocationFocusNode;
  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get phoneNumberFocusNode => _phoneNumberFocusNode;
  FocusNode get cityFocusNode => _cityFocusNode;
  FocusNode get stateFocusNode => _stateFocusNode;
  FocusNode get countryFocusNode => _countryFocusNode;
  FocusNode get pinCodeFocusNode => _pinCodeFocusNode;
  FocusNode get addressFocusNode => _addressFocusNode;
  FocusNode get additionalAddressFocusNode => _additionalAddressFocusNode;
  FocusNode get longitudeFocusNode => _longitudeFocusNode;
  FocusNode get latitudeFocusNode => _latitudeFocusNode;

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }
}
