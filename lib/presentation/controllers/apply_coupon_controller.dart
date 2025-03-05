import 'package:flutter/material.dart';
import '../../data/services/apply_coupon_service.dart';

class ApplyCouponController extends ChangeNotifier {
  bool _searchLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List _searchResults = [];

  //public getters
  bool get searchLoading => _searchLoading;
  bool get isSearching => _isSearching;
  List get searchResults => _searchResults;

  TextEditingController get searchController => _searchController;
  FocusNode get searchFocusNode => _searchFocusNode;

  void setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  Future<void> performSearch(BuildContext context) async {
    _searchLoading = true;
    notifyListeners();

    _searchResults = await ApplyCouponService.fetchCoupons(
        context, _searchController.text.trim());

    _searchLoading = false;
    _isSearching = _searchResults.isNotEmpty;
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _searchController.clear();
    notifyListeners();
  }
}
