import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import '../screens/order_details/order_details.dart';
import '../screens/orders_page/widgets/header_cell.dart';
import '../screens/orders_page/widgets/order_actions.dart';
import '../screens/orders_page/widgets/order_cell.dart';
import '../screens/orders_page/widgets/order_status.dart';

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
  final List<Map<String, String>> _orders = [
    {
      "Order ID": "ORD123",
      "Order Date": "27 Dec 2025",
      "Order Date2": "01:11 PM",
      "Customer Info": "Adidas White For Men",
      "Customer Info2": "09016482578",
      "Total Amount": "250.00",
      "Total Amount Status": "Paid",
      "Order Status": "Confirmed",
      "Order Type": "Home Delivery",
    },
    {
      "Order ID": "ORD124",
      "Order Date": "27 Dec 2025",
      "Order Date2": "01:11 PM",
      "Customer Info": "Jane Smith",
      "Customer Info2": "09106482578",
      "Total Amount": "120.00",
      "Total Amount Status": "Unpaid",
      "Order Status": "Pending",
      "Order Type": "Home Delivery",
    },
    {
      "Order ID": "ORD124",
      "Order Date": "27 Dec 2025",
      "Order Date2": "01:11 PM",
      "Customer Info": "Jane Smith",
      "Customer Info2": "09106482578",
      "Total Amount": "120.00",
      "Total Amount Status": "Unpaid",
      "Order Status": "Pending",
      "Order Type": "Home Delivery",
    },
    // Add more orders here
  ];

  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  OrdersPageController(
      {required this.onToggleDarkMode, required this.isDarkMode});
  List<Widget> _buildHeaders() {
    return [
      const HeaderCell(title: "#", width: 50),
      const HeaderCell(title: "Order Id", width: 150),
      const HeaderCell(title: "Order Date", width: 150),
      const HeaderCell(title: "Customer Info", width: 200),
      const HeaderCell(title: "Total Amount", width: 150),
      const HeaderCell(title: "Order Status", width: 150),
      const HeaderCell(title: "Actions", width: 100),
    ];
  }

  List<Widget> _buildLeftColumn() {
    return List.generate(
      _orders.length,
      (index) => OrderCell(text: "${index + 1}", width: 50, height: 70),
    );
  }

  List<Widget> _buildRightColumns() {
    return List.generate(
      _orders.length,
      (index) => InkWell(
        onTap: () {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => OrderDetails(
                key: UniqueKey(),
                onToggleDarkMode: onToggleDarkMode,
                isDarkMode: isDarkMode,
                order: _orders,
                id: _orders[index]["Order ID"]!,
                name: _orders[index]["Customer Info"]!,
                date: _orders[index]["Order Date"]!,
                date2: _orders[index]["Order Date2"]!,
                amount: _orders[index]["Total Amount"]!,
                amountStatus: _orders[index]["Total Amount Status"]!,
                orderType: _orders[index]["Order Type"]!,
                orderStatus: _orders[index]["Order Status"]!,
              ),
            ),
          );
        },
        child: Row(
          children: [
            OrderCell(
                text: _orders[index]["Order ID"]!, width: 150, height: 70),
            OrderCell(
                text: _orders[index]["Order Date"]!,
                text2: _orders[index]["Order Date2"]!,
                width: 150,
                height: 70),
            OrderCell(
                text: _orders[index]["Customer Info"]!,
                text2: _orders[index]["Customer Info2"]!,
                width: 200,
                height: 70),
            OrderCell(
                text: _orders[index]["Total Amount"]!,
                text2: _orders[index]["Total Amount Status"]!,
                width: 150,
                isAmount: true,
                height: 70),
            OrderStatus(
                text: _orders[index]["Order Status"]!,
                text2: _orders[index]["Order Type"]!,
                width: 150,
                height: 70),
            const OrderActions(width: 150, height: 70),
          ],
        ),
      ),
    );
  }

  //public getters
  bool get isSearching => _isSearching;
  bool get searchLoading => _searchLoading;
  List<dynamic> get searchResults => _searchResults;
  int? get selectedRadioValue => _selectedRadioValue;
  int? get selectedRadioValue2 => _selectedRadioValue2;
  List<Map<String, String>> get orders => _orders;
  List<Widget> Function() get buildHeaders => _buildHeaders;
  List<Widget> Function() get buildLeftColumn => _buildLeftColumn;
  List<Widget> Function() get buildRightColumns => _buildRightColumns;

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

  void setSelectedRadioValue2(int value) {
    _selectedRadioValue2 = value;
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
