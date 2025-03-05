import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/auth/sign_in_page.dart';
import '../screens/my_cart/my_cart.dart';

class TopCategoriesDetailsController extends ChangeNotifier {
  Map<String, bool> _isLikedMap = {};
  List<Map<String, dynamic>> _products = [];
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  List<Map<String, dynamic>> filteredProducts = [];
  bool _isSearching = false; // To track if the search is active
  String _searchQuery = ''; // To store the current search query
  List<Map<String, dynamic>> _searchResults = []; // To store the search results
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int pageNum = 1;
  bool _isFetchingMore = false;
  bool hasMore = true;
  final int? id;
  final bool discountOnly;

  TopCategoriesDetailsController(
      {required this.id, required this.discountOnly}) {
    initialize();
  }

  //public getters
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isFetchingMore => _isFetchingMore;
  List<Map<String, dynamic>> get products => _products;

  TextEditingController get searchController => _searchController;
  ScrollController get scrollController => _scrollController;

  FocusNode get searchFocusNode => _searchFocusNode;

  //public setters
  void setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  void initialize() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        if (products.isEmpty) {
          fetchProducts(overwrite: true);
        }
      }
    });
    fetchProducts(overwrite: true);
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false; // Reset search state
    searchResults.clear(); // Clear search results
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty; // Set searching state based on query

    if (_isSearching) {
      // Check if products are filtered
      List<Map<String, dynamic>> sourceList =
          discountOnly ? filteredProducts : products;

      _searchResults = sourceList.where((product) {
        // Check for null to avoid NoSuchMethodError
        final productName = product['name'];
        return productName != null &&
            productName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      searchResults.clear(); // Clear search results if query is empty
    }
    notifyListeners();
  }

  void filterProducts() {
    filteredProducts = products.where((product) {
      // Add your filtering logic here
      return product['hasDiscount'] == true;
    }).toList();
    notifyListeners();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        !_isFetchingMore) {
      fetchMoreProducts(); // Trigger fetching more products
    }
  }

  Future<void> fetchProducts({bool overwrite = false}) async {
    if (_isLoading) return; // Prevent multiple fetches

    _isLoading = true;
    notifyListeners();

    if (overwrite) {
      // Clear existing products and reset pagination
      products.clear();
      pageNum = 1;
      hasMore = true; // Reset `hasMore` for a fresh fetch
    }

    try {
      if (id != null) {
        await _fetchProductsForPageBasedOnCategory(pageNum);
      } else {
        await _fetchProductsForPage(pageNum);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreProducts() async {
    if (!hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    notifyListeners();

    pageNum++; // Increment the page number for the next fetch

    try {
      if (id != null) {
        await _fetchProductsForPageBasedOnCategory(pageNum);
      } else {
        await _fetchProductsForPage(pageNum);
      }
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
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

        if (responseData.isEmpty) {
          hasMore = false; // No more pages to fetch
        } else {
          // Filter out duplicate products
          final newProducts = responseData.where((product) {
            return !products.any(
                (existingProduct) => existingProduct['id'] == product['id']);
          }).map((product) {
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
          }).toList();

          if (newProducts.isNotEmpty) {
            products.addAll(newProducts);
          } else {
            hasMore = false; // No new products means end of list
          }
        }
        notifyListeners();
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchProductsForPageBasedOnCategory(int page) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url =
        'https://ojawa-api.onrender.com/api/Products/category/$id?page=$page';

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

        if (responseData.isEmpty) {
          hasMore = false;
        } else {
          final newProducts = responseData.where((product) {
            return !products.any(
                (existingProduct) => existingProduct['id'] == product['id']);
          }).map((product) {
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
          }).toList();

          if (newProducts.isNotEmpty) {
            products.addAll(newProducts);
          } else {
            hasMore = false;
          }
        }
        notifyListeners();
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateFavoriteStatus(int productId, bool isFavorite) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Favorites/$productId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode == 200) {
        print('Favorite status updated successfully.');
      } else {
        print(
            'Failed to update favorite status: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void loadCart(BuildContext context, dynamic Function(bool) onToggleDarkMode,
      bool isDarkMode) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      CustomSnackbar.show(
        'You are not logged in.',
        isError: true,
      );
      // await prefs.remove('user');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode),
        ),
      );

      _isLoading = false;
      notifyListeners();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCart(key: UniqueKey()),
      ),
    );
  }
}
