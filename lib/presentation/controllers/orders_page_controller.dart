import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/widgets/custom_snackbar.dart';

class OrdersPageController extends ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List _searchResults = [];
  bool _searchLoading = false;
  bool _isSearching = false;
  final storage = const FlutterSecureStorage();
  int? _selectedRadioValue = 0;
  int? _selectedRadioValue2 = 0;
  String? _userName;
  String? _profileImg;

  //public getters
  bool get isSearching => _isSearching;
  bool get searchLoading => _searchLoading;
  List<dynamic> get searchResults => _searchResults;
  int? get selectedRadioValue => _selectedRadioValue;

  TextEditingController get searchController => _searchController;

  FocusNode get searchFocusNode => _searchFocusNode;

  void setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  Future<void> performSearch(String query) async {
    _searchLoading = true;
    notifyListeners();
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://signal.payguru.com.ng/api/search?query=$query';
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // Perform GET request
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      _searchResults = jsonDecode(response.body);
      _searchLoading = false;
      notifyListeners();
    } else if (response.statusCode == 404) {
      _searchResults = [];
      _searchLoading = false;
      notifyListeners();
      CustomSnackbar.show(
        'No results found for the query.',
        isError: true,
      );
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      _searchResults = [];
      _searchLoading = false;
      notifyListeners();
      final errorMessage = jsonDecode(response.body)['message'];
      CustomSnackbar.show(
        errorMessage,
        isError: true,
      );
    }
  }
}
