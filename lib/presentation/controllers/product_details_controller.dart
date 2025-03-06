import '../../core/widgets/custom_snackbar.dart';
import '../../core/widgets/error_dialog.dart';
import '../../core/widgets/no_internet_dialog.dart';
import '../../core/widgets/time_out_error_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../screens/auth/sign_in_page.dart';
import '../screens/my_cart/my_cart.dart';
import '../screens/write_review/write_review.dart';

class ProductDetailsController extends ChangeNotifier {
  List<String> _imagePaths = [
    "images/Img2.png",
    "images/Img5.png",
    "images/Img5.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool _isLiked = false;
  int? _selectedRadioValue = 0;
  final FocusNode _pinFocusNode = FocusNode();
  final TextEditingController _pinController = TextEditingController();
  Map<String, bool> _isLikedMap = {};
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _productDetails;
  bool _isLoading2 = true;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int _pageNum = 1;
  bool _isFetchingMore = false;
  bool _isLoading = false;
  List<String> _itemImgList = [];
  List<String> _fullImgList = [];
  List<Map<String, dynamic>> _reviews = [];
  int _totalUsers = 0; // Default value of 0
  int _totalReviews = 0; // Default value of 0
  Map<String, dynamic>? _firstHighlyRatedReview; // Can be null initially
  List<Map<String, dynamic>> _simplifiedReviews = [];
  List<Map<String, dynamic>> _simplifiedRatings = [];
  Map<String, dynamic>? _firstReview = {};
  String _overallRating = '0';
  int _totalPeopleRated = 0;
  bool _isRefreshing = false;

  final int itemId;

  ProductDetailsController({required this.itemId}) {
    initialize();
  }

  //public getters
  int get current => _current;
  List<String> get imagePaths => _imagePaths;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get productDetails => _productDetails;
  bool get isFetchingMore => _isFetchingMore;
  List<Map<String, dynamic>> get products => _products;
  Map<String, bool> get isLikedMap => _isLikedMap;
  bool get isLiked => _isLiked;
  List<String> get fullImgList => _fullImgList;
  bool get isLoading2 => _isLoading2;
  int get totalPeopleRated => _totalPeopleRated;
  String get overallRating => _overallRating;
  Map<String, dynamic>? get firstReview => _firstReview;
  List<Map<String, dynamic>> get simplifiedReviews => _simplifiedReviews;
  int? get selectedRadioValue => _selectedRadioValue;

  CarouselController get controller => _controller;
  ScrollController get scrollController => _scrollController;
  TextEditingController get pinController => _pinController;

  FocusNode get pinFocusNode => _pinFocusNode;

  void setCurrent(int value) {
    _current = value;
    notifyListeners();
  }

  void setIsLikedMap(Map<String, bool> value) {
    _isLikedMap = value;
    notifyListeners();
  }

  void setIsLiked(bool value) {
    _isLiked = value;
  }

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void initialize() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchProducts();
        _fetchProductDetails(itemId);
      }
    });
    fetchProducts();
    _fetchProductDetails(itemId);
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //         _scrollController.position.maxScrollExtent &&
    //     !_isLoading2 &&
    //     !_isFetchingMore) {
    //   fetchMoreProducts(); // Trigger fetching more products
    // }
  }

  Future<void> fetchProducts() async {
    _isLoading2 = true;
    notifyListeners();
    await _fetchProductsForPage(_pageNum);

    _isLoading2 = false;
    notifyListeners();
  }

  Future<void> fetchMoreProducts() async {
    _isFetchingMore = true;
    notifyListeners();
    _pageNum++; // Increment the page number for the next set of products
    await _fetchProductsForPage(_pageNum);

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

  Future<void> _fetchProductDetails(int productId) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products/$productId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];

        _productDetails = {
          'id': responseData['id'] ?? 0, // Default to 0 if null
          'name': responseData['name'] ??
              'Unknown Product', // Default to 'Unknown Product'
          'status': responseData['status'] ??
              'Unavailable', // Default to 'Unavailable'
          'dateCreated':
              responseData['dateCreated'] ?? 'N/A', // Default to 'N/A'
          'dateUpdated': responseData['dateUpdated'] ?? 'N/A',
          'description':
              responseData['description'] ?? 'No description available',
          'img': responseData['productImageUrl'] ??
              '', // Default to an empty string
          'quantity': responseData['quantity'] ?? 0, // Default to 0
          'rating': responseData['rating']?.toString() ?? '0', // Default to '0'
          'discountRate': responseData['hasDiscount'] == true
              ? '${responseData['discountRate'] ?? 0}% OFF'
              : '',
          'uptoDiscount': responseData['hasDiscount'] == true
              ? 'Upto ${responseData['discountRate'] ?? 0}% OFF'
              : '',
          'price': '\$${responseData['price'] ?? 0.0}', // Default to $0.0
          'slashedPrice': responseData['hasDiscount'] == true
              ? '\$${responseData['discountPrice'] ?? 0.0}'
              : '',
          'isInFavorite':
              responseData['isInFavorite'] ?? false, // Default to false
          'category': responseData['category'] != null
              ? {
                  'id': responseData['category']['id'] ?? 0,
                  'name':
                      responseData['category']['name'] ?? 'Unknown Category',
                  'description': responseData['category']['description'] ?? '',
                  'img': responseData['category']['categoryImageUrl'] ?? '',
                }
              : {
                  'id': 0,
                  'name': '',
                  'description': '',
                  'img': ''
                }, // Default empty category
          'attributes':
              responseData['attributes'] ?? [], // Default to an empty list
          'reviews': responseData['reviews']?.map((review) {
                return {
                  'reviewId': review['reviewId'] ?? 0,
                  'headline': review['headline'] ?? '',
                  'body': review['body'] ?? '',
                  'dateCreated': review['dateCreated'] ?? '',
                  'dateUpdated': review['dateUpdated'] ?? '',
                  'username': review['username'] ?? 'Anonymous',
                  'userProfilePictureUrl':
                      review['userProfilePictureUrl'] ?? '',
                  'rating': review['value'] ?? 0,
                };
              }).toList() ??
              [],
          'ratings': responseData['ratings']?.map((rating) {
                return {
                  'ratingId': rating['ratingId'] ?? 0,
                  'value': rating['value'] ?? 0,
                  'username': rating['username'] ?? 'Anonymous',
                  'dateCreated': rating['dateCreated'] ?? '',
                  'dateUpdated': rating['dateUpdated'] ?? '',
                  'userProfilePictureUrl':
                      rating['userProfilePictureUrl'] ?? '',
                };
              }).toList() ??
              [],
        };
        _isLiked = productDetails!['isInFavorite'];
        if (productDetails!['img'] != null) {
          if (productDetails!['img'] is List<String>) {
            _itemImgList = List<String>.from(productDetails!['img']);
          } else if (productDetails!['img'] is String) {
            _itemImgList = [productDetails!['img']];
          }
        }
        _fullImgList = _itemImgList.map((img) {
          return '$img/download?project=677181a60009f5d039dd';
        }).toList();
        print("Product Details: $productDetails");
        // Use productDetails to update your UI or store it in state

        List<Map<String, dynamic>> reviews =
            List<Map<String, dynamic>>.from(productDetails!['reviews'] ?? []);
        List<Map<String, dynamic>> ratings =
            List<Map<String, dynamic>>.from(productDetails!['ratings'] ?? []);

        // 1. Total users who made a review
        _totalUsers =
            reviews.map((review) => review['username']).toSet().length;

        // 2. Total reviews
        _totalReviews = reviews.length;

        // Extract specific fields from all reviews
        // Extract specific fields from all reviews
        _simplifiedReviews = reviews.map((review) {
          String userProfilePictureUrl = review['userProfilePictureUrl'];
          if (userProfilePictureUrl == null || userProfilePictureUrl.isEmpty) {
            userProfilePictureUrl =
                'images/Profile.png'; // Default profile picture
            print("Default picture");
          } else {
            userProfilePictureUrl =
                "$userProfilePictureUrl/download?project=677181a60009f5d039dd";
            print("Real picture");
          }

          return {
            'headline': review['headline'] ?? 'No headline',
            'username': review['username'] ?? 'Anonymous',
            'dateCreated': review['dateCreated'] ?? 'N/A',
            'body': review['body'] ?? 'No body available',
            'userProfilePictureUrl':
                userProfilePictureUrl, // Use the processed value
            'rating': review['value'] ?? 0,
          };
        }).toList();

// Extract specific fields from all ratings
        _simplifiedRatings = ratings.map((rating) {
          return {
            'username': rating['username'] ?? 'Anonymous',
            'dateCreated': rating['dateCreated'] ?? 'N/A',
            'value': rating['value'] ?? 0,
          };
        }).toList();

        _firstReview =
            simplifiedReviews.isNotEmpty ? simplifiedReviews[0] : null;

        if (firstReview != null) {
          print(
              'Raw userProfilePictureUrl: ${firstReview!['userProfilePictureUrl']}');
        } else {
          print('No reviews available for firstReview.');
        }

// Extract ratings and calculate the overall rating
        if (ratings.isNotEmpty) {
          // Calculate the total ratings value
          final totalRatingsValue = ratings.fold<double>(
            0.0,
            (sum, rating) => sum + (rating['value'] ?? 0).toDouble(),
          );

          // Total number of people who rated
          _totalPeopleRated = ratings.length;

          // Calculate the average rating (rounded to 1 decimal place)
          final averageRating =
              (totalRatingsValue / totalPeopleRated).toStringAsFixed(1);

          // Example: Display ratings as "4.6/5"
          _overallRating = averageRating;

          print('Total People Rated: $totalPeopleRated');
          print('Overall Rating: $overallRating');
        } else {
          _overallRating = '0';
          _totalPeopleRated = 0;
        }

// Output the simplified lists
        print('Simplified Reviews: $simplifiedReviews');
        print('Simplified Ratings: $_simplifiedRatings');

        // Print the results
        print('Total Users Who Made a Review: $_totalUsers');
        print('Total Reviews: $_totalReviews');
        if (_firstHighlyRatedReview != null) {
          print('First Highly Rated Review: $_firstHighlyRatedReview');
        } else {
          print('No reviews available.');
        }
        notifyListeners();
      } else {
        print('Error fetching product details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateFavoriteStatus(
      BuildContext context,
      int productId,
      bool isFavorite,
      dynamic Function(bool) onToggleDarkMode,
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

  Future<void> addToCart(BuildContext context, int productId, int quantity,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    _isLoading = true;
    notifyListeners();
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
    final url = 'https://ojawa-api.onrender.com/api/Carts';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productId': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCart(key: UniqueKey()),
          ),
        );
        print('Item added to cart successfully');
        CustomSnackbar.show(
          'Item added to cart successfully',
          isError: false,
        );

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        print('Failed to add item to cart: ${response.body}');
        CustomSnackbar.show(
          'Failed to add item to cart',
          isError: true,
        );
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print('Error: $error');
      CustomSnackbar.show(
        'Failed to add item to cart',
        isError: true,
      );
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
        _fetchProductDetails(itemId),
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

  void loadWriteReviewPage(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
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
        builder: (context) => WriteReviewPage(
            key: UniqueKey(),
            productId: productDetails!['id'],
            productImg: fullImgList[0],
            rating: int.parse(productDetails!['rating'])),
      ),
    );
  }
}
