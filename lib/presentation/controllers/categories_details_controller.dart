import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../core/widgets/error_dialog.dart';
import '../../core/widgets/no_internet_dialog.dart';
import '../../core/widgets/time_out_error_dialog.dart';

class CategoriesDetailsController extends ChangeNotifier {
  final List<String> _imagePaths = [
    "images/Banner.png",
    "images/Banner.png",
    "images/Banner.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  Map<String, bool> _isLikedMap = {};
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  bool _isLoading2 = true;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int pageNum = 1;
  bool _isFetchingMore = false;

  bool _isRefreshing = false;

  CategoriesDetailsController() {
    initialize();
  }

  //public getters
  int get current => _current;
  List<String> get imagePaths => _imagePaths;
  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isFetchingMore => _isFetchingMore;
  List<Map<String, dynamic>> get products => _products;
  Map<String, bool> get isLikedMap => _isLikedMap;

  CarouselController get controller => _controller;
  ScrollController get scrollController => _scrollController;

  void setCurrent(int value) {
    _current = value;
    notifyListeners();
  }

  void setIsLikedMap(Map<String, bool> value) {
    _isLikedMap = value;
    notifyListeners();
  }

  void initialize() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchCategories();
        fetchProducts();
      }
    });
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    final String? accessToken = await storage.read(key: 'accessToken');
    final url =
        'https://ojawa-api.onrender.com/api/Products/categories'; // Update with your categories endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        _categories = responseData.map((category) {
          return {
            'id': category['id'],
            'name': category['name'],
            'description': category['description'],
            'categoryImageUrl':
                category['categoryImageUrl'], // Add the image URL
          };
        }).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error: $error');
    }
  }

  String getImageUrl(int index) {
    switch (index) {
      case 0:
        return 'images/Img4.png';
      case 1:
        return 'images/Img5.png';
      case 2:
        return 'images/Img6.png';
      case 3:
        return 'images/Img4.png';
      case 4:
        return 'images/Img5.png';
      case 5:
        return 'images/Img6.png';
      default:
        return '';
    }
  }

  String getImageLabel(int index) {
    switch (index) {
      case 0:
        return 'Formal Wear';
      case 1:
        return 'Ethnic Wear';
      case 2:
        return 'Sports Wear';
      case 3:
        return 'Casual Wear';
      case 4:
        return 'Footwear';
      case 5:
        return 'Accessories';
      default:
        return '';
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading2 &&
        !_isFetchingMore) {
      //fetchMoreProducts(); // Trigger fetching more products
    }
  }

  Future<void> fetchProducts() async {
    _isLoading2 = true;
    notifyListeners();
    await _fetchProductsForPage(pageNum);

    _isLoading2 = false;
    notifyListeners();
  }

  Future<void> fetchMoreProducts() async {
    _isFetchingMore = true;
    notifyListeners();
    pageNum++; // Increment the page number for the next set of products
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

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        _products.addAll(responseData.map((product) {
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
        _isLoading2 = false;
        notifyListeners();
      } else {
        _isLoading2 = false;
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      _isLoading2 = false;
      print('Error: $error');
    }
  }

  Future<void> refreshData(BuildContext context) async {
    _isRefreshing = true;
    notifyListeners();

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        showNoInternetDialog(context, refreshData);

        _isRefreshing = false;
        notifyListeners();
        return;
      }

      await Future.any([
        Future.delayed(const Duration(seconds: 15), () {
          throw TimeoutException('The operation took too long.');
        }),
        fetchProducts(),
        fetchCategories(),
      ]);
    } catch (e) {
      if (e is TimeoutException) {
        showTimeoutDialog(context, refreshData);
      } else {
        showErrorDialog(context, e.toString());
      }
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }
}
