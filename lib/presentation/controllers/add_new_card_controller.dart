import 'package:flutter/material.dart';

class AddNewCardController extends ChangeNotifier {
  final bool _isLoading = false;
  final FocusNode _cardHolderNameFocusNode = FocusNode();
  final FocusNode _cardNumberFocusNode = FocusNode();
  final FocusNode _expiryDateFocusNode = FocusNode();
  final FocusNode _ccvFocusNode = FocusNode();

  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _ccvController = TextEditingController();

//public getters
  bool get isLoading => _isLoading;

  FocusNode get cardHolderNameFocusNode => _cardHolderNameFocusNode;
  FocusNode get cardNumberFocusNode => _cardNumberFocusNode;
  FocusNode get expiryDateFocusNode => _expiryDateFocusNode;
  FocusNode get ccvFocusNode => _ccvFocusNode;

  TextEditingController get cardHolderNameController =>
      _cardHolderNameController;
  TextEditingController get cardNumberController => _cardNumberController;
  TextEditingController get expiryDateController => _expiryDateController;
  TextEditingController get ccvController => _ccvController;
}
