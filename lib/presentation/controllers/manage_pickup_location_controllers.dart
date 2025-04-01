import 'package:flutter/material.dart';

class ManagePickupLocationControllers extends ChangeNotifier {
  bool _isLoading = false;
  int? _selectedRadioValue = 0;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _selectTaxController = TextEditingController();
  final TextEditingController _selectIndicatorController =
      TextEditingController();
  final TextEditingController _productMadeInController =
      TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalAllowedQuantityController =
      TextEditingController();
  final TextEditingController _minimumOrderQuantityController =
      TextEditingController();
  final TextEditingController _quantityStepSizeController =
      TextEditingController();
  final TextEditingController _warrantyPeriodController =
      TextEditingController();
  final TextEditingController _guaranteePeriodController =
      TextEditingController();
  final TextEditingController _deliverableTypeController =
      TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _pickUpLocationController =
      TextEditingController();

  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _tagsFocusNode = FocusNode();
  final FocusNode _productTypeFocusNode = FocusNode();
  final FocusNode _selectTaxFocusNode = FocusNode();
  final FocusNode _selectIndicatorFocusNode = FocusNode();
  final FocusNode _productMadeInFocusNode = FocusNode();
  final FocusNode _hsnCodeFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _totalAllowedQuantityFocusNode = FocusNode();
  final FocusNode _minimumOrderQuantityFocusNode = FocusNode();
  final FocusNode _quantityStepSizeFocusNode = FocusNode();
  final FocusNode _warrantyPeriodFocusNode = FocusNode();
  final FocusNode _guaranteePeriodFocusNode = FocusNode();
  final FocusNode _deliverableTypeFocusNode = FocusNode();
  final FocusNode _zipCodeFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _pickUpLocationFocusNode = FocusNode();

  //public getters
  bool get isLoading => _isLoading;
  int? get selectedRadioValue => _selectedRadioValue;

  TextEditingController get productNameController => _productNameController;
  TextEditingController get tagsController => _tagsController;
  TextEditingController get productTypeController => _productTypeController;
  TextEditingController get selectTaxController => _selectTaxController;
  TextEditingController get selectIndicatorController =>
      _selectIndicatorController;
  TextEditingController get productMadeInController => _productMadeInController;
  TextEditingController get hsnCodeController => _hsnCodeController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get totalAllowedQuantityController =>
      _totalAllowedQuantityController;
  TextEditingController get minimumOrderQuantityController =>
      _minimumOrderQuantityController;
  TextEditingController get quantityStepSizeController =>
      _quantityStepSizeController;
  TextEditingController get warrantyPeriodController =>
      _warrantyPeriodController;
  TextEditingController get guaranteePeriodController =>
      _guaranteePeriodController;
  TextEditingController get deliverableTypeController =>
      _deliverableTypeController;
  TextEditingController get zipCodeController => _zipCodeController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get brandController => _brandController;
  TextEditingController get pickUpLocationController =>
      _pickUpLocationController;

  FocusNode get productNameFocusNode => _productNameFocusNode;
  FocusNode get tagsFocusNode => _tagsFocusNode;
  FocusNode get productTypeFocusNode => _productTypeFocusNode;
  FocusNode get selectTaxFocusNode => _selectTaxFocusNode;
  FocusNode get selectIndicatorFocusNode => _selectIndicatorFocusNode;
  FocusNode get productMadeInFocusNode => _productMadeInFocusNode;
  FocusNode get hsnCodeFocusNode => _hsnCodeFocusNode;
  FocusNode get descriptionFocusNode => _descriptionFocusNode;
  FocusNode get totalAllowedQuantityFocusNode => _totalAllowedQuantityFocusNode;
  FocusNode get minimumOrderQuantityFocusNode => _minimumOrderQuantityFocusNode;
  FocusNode get quantityStepSizeFocusNode => _quantityStepSizeFocusNode;
  FocusNode get warrantyPeriodFocusNode => _warrantyPeriodFocusNode;
  FocusNode get guaranteePeriodFocusNode => _guaranteePeriodFocusNode;
  FocusNode get deliverableTypeFocusNode => _deliverableTypeFocusNode;
  FocusNode get zipCodeFocusNode => _zipCodeFocusNode;
  FocusNode get categoryFocusNode => _categoryFocusNode;
  FocusNode get brandFocusNode => _brandFocusNode;
  FocusNode get pickUpLocationFocusNode => _pickUpLocationFocusNode;
}
