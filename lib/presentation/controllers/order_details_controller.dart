import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../screens/order_details/widgets/order_setup.dart';
import '../screens/orders_page/widgets/header_cell.dart';
import '../screens/orders_page/widgets/order_cell.dart';

class OrderDetailsController extends ChangeNotifier {
  Map<String, bool> _isLikedMap = {};
  List<Map<String, dynamic>> _products = [];
  final storage = const FlutterSecureStorage();
  bool _isLoading = true;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  int _pageNum = 1;
  bool _isFetchingMore = false;
  List<Widget> _buildHeaders() {
    return [
      const HeaderCell(title: "#", width: 50),
      const HeaderCell(title: "Item Details", width: 350),
      const HeaderCell(title: "Addons", width: 150),
      const HeaderCell(title: "Price", width: 200),
    ];
  }

  List<Widget> _buildLeftColumn(int orderLength) {
    return List.generate(
      orderLength,
      (index) => OrderCell(text: "${index + 1}", width: 50),
    );
  }

  List<Widget> _buildRightColumns(int orderLength, String name, String amount) {
    return List.generate(
      orderLength,
      (index) => Row(
        children: [
          OrderSetup(img: 'images/Img6.png', text: name, width: 350),
          const OrderSetup(text: "", text2: "", width: 200),
          OrderSetup(text: amount, width: 200),
        ],
      ),
    );
  }

  OrderDetailsController() {
    initialize();
  }

  //public getters
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get products => _products;
  int get pageNum => _pageNum;
  List<Widget> Function() get buildHeaders => _buildHeaders;
  List<Widget> Function(int orderLength) get buildLeftColumn =>
      _buildLeftColumn;
  List<Widget> Function(int orderLength, String name, String amount)
      get buildRightColumns => _buildRightColumns;

  void initialize() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchProducts();
      }
    });
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    await _fetchProductsForPage(pageNum);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreProducts() async {
    _isFetchingMore = true;
    notifyListeners();
    _pageNum++; // Increment the page number for the next set of products
    await _fetchProductsForPage(pageNum);

    _isFetchingMore = false;
    notifyListeners();
  }

  Future<void> _fetchProductsForPage(int page) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products?page=$page';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        products.addAll(responseData.map((product) {
          String discount = product['hasDiscount'] == true
              ? '${product['discountRate']}% OFF'
              : '';
          String uptoDiscount = product['hasDiscount'] == true
              ? 'Upto ${product['discountRate']}% OFF'
              : '';
          return {
            'id': product['id'],
            'name': product['name'],
            'img': product['productImageUrl'],
            'details': product['description'],
            'amount': '\$${product['price']}',
            'slashedPrice': product['hasDiscount'] == true
                ? '\$${product['discountPrice']}'
                : '',
            'isInFavorite': product['isInFavorite'] ?? false,
            'discount': discount,
            'uptoDiscount': uptoDiscount,
            'starImg': 'images/Rating Icon.png',
            'rating': product['rating'].toString(),
            'rating2': '(0)',
            'hasDiscount': product['hasDiscount'],
          };
        }).toList());
        notifyListeners();
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
