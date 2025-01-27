import 'dart:convert';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ojawa/my_cart.dart';
import 'package:ojawa/sign_in_page.dart';
import 'package:ojawa/top_categories_details.dart';
import 'package:ojawa/write_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Productdetails extends StatefulWidget {
  final int itemId;
  final List<String> img;
  final String name;
  final String details;
  final String amount;
  final String slashedPrice;
  final String rating;
  final String rating2;
  final String discount;
  final String starImg;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const Productdetails(
      {super.key,
      required this.itemId,
      required this.name,
      required this.details,
      required this.amount,
      required this.slashedPrice,
      required this.rating,
      required this.rating2,
      required this.img,
      required this.discount,
      required this.starImg,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails>
    with TickerProviderStateMixin, RouteAware {
  List<String> imagePaths = [
    "images/Img2.png",
    "images/Img5.png",
    "images/Img5.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isLiked = false;
  int? _selectedRadioValue;
  final FocusNode _pinFocusNode = FocusNode();
  final TextEditingController pinController = TextEditingController();
  Map<String, bool> _isLikedMap = {};
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> products = [];
  Map<String, dynamic>? productDetails;
  bool _isLoading = true;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int pageNum = 1;
  bool _isFetchingMore = false;
  bool isLoading = false;
  List<String> itemImgList = [];
  List<String> fullImgList = [];
  List<Map<String, dynamic>> reviews = [];
  int totalUsers = 0; // Default value of 0
  int totalReviews = 0; // Default value of 0
  Map<String, dynamic>? firstHighlyRatedReview; // Can be null initially
  List<Map<String, dynamic>> simplifiedReviews = [];
  List<Map<String, dynamic>> simplifiedRatings = [];
  Map<String, dynamic>? firstReview = {};
  String overallRating = '0';
  int totalPeopleRated = 0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchProducts();
        _fetchProductDetails(widget.itemId);
      }
    });
    fetchProducts();
    _fetchProductDetails(widget.itemId);
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //         _scrollController.position.maxScrollExtent &&
    //     !_isLoading &&
    //     !_isFetchingMore) {
    //   fetchMoreProducts(); // Trigger fetching more products
    // }
  }

  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchProductsForPage(pageNum);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMoreProducts() async {
    setState(() {
      _isFetchingMore = true;
    });
    pageNum++; // Increment the page number for the next set of products
    await _fetchProductsForPage(pageNum);
    setState(() {
      _isFetchingMore = false;
    });
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
        setState(() {
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
              'discount': discount,
              'uptoDiscount': uptoDiscount,
              'starImg': 'images/Rating Icon.png',
              'rating': product['rating'].toString(),
              'rating2': '(0)',
              'hasDiscount': product['hasDiscount'],
            };
          }).toList());
        });
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

        setState(() {
          productDetails = {
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
            'rating':
                responseData['rating']?.toString() ?? '0', // Default to '0'
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
                    'description':
                        responseData['category']['description'] ?? '',
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
          isLiked = productDetails!['isInFavorite'];
          if (productDetails!['img'] != null) {
            if (productDetails!['img'] is List<String>) {
              itemImgList = List<String>.from(productDetails!['img']);
            } else if (productDetails!['img'] is String) {
              itemImgList = [productDetails!['img']];
            }
          }
          fullImgList = itemImgList.map((img) {
            return '$img/download?project=677181a60009f5d039dd';
          }).toList();
          print("Product Details: $productDetails");
          // Use productDetails to update your UI or store it in state

          List<Map<String, dynamic>> reviews =
              List<Map<String, dynamic>>.from(productDetails!['reviews'] ?? []);
          List<Map<String, dynamic>> ratings =
              List<Map<String, dynamic>>.from(productDetails!['ratings'] ?? []);

          // 1. Total users who made a review
          totalUsers =
              reviews.map((review) => review['username']).toSet().length;

          // 2. Total reviews
          totalReviews = reviews.length;

          // Extract specific fields from all reviews
          // Extract specific fields from all reviews
          simplifiedReviews = reviews.map((review) {
            String userProfilePictureUrl = review['userProfilePictureUrl'];
            if (userProfilePictureUrl == null ||
                userProfilePictureUrl.isEmpty) {
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
          simplifiedRatings = ratings.map((rating) {
            return {
              'username': rating['username'] ?? 'Anonymous',
              'dateCreated': rating['dateCreated'] ?? 'N/A',
              'value': rating['value'] ?? 0,
            };
          }).toList();

          firstReview =
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
            totalPeopleRated = ratings.length;

            // Calculate the average rating (rounded to 1 decimal place)
            final averageRating =
                (totalRatingsValue / totalPeopleRated).toStringAsFixed(1);

            // Example: Display ratings as "4.6/5"
            overallRating = averageRating;

            print('Total People Rated: $totalPeopleRated');
            print('Overall Rating: $overallRating');
          } else {
            overallRating = '0';
            totalPeopleRated = 0;
          }

// Output the simplified lists
          print('Simplified Reviews: $simplifiedReviews');
          print('Simplified Ratings: $simplifiedRatings');

          // Print the results
          print('Total Users Who Made a Review: $totalUsers');
          print('Total Reviews: $totalReviews');
          if (firstHighlyRatedReview != null) {
            print('First Highly Rated Review: $firstHighlyRatedReview');
          } else {
            print('No reviews available.');
          }
        });
      } else {
        print('Error fetching product details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateFavoriteStatus(int productId, bool isFavorite) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      _showCustomSnackBar(
        context,
        'You are not logged in.',
        isError: true,
      );
      // await prefs.remove('user');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(
              key: UniqueKey(),
              onToggleDarkMode: widget.onToggleDarkMode,
              isDarkMode: widget.isDarkMode),
        ),
      );
      setState(() {
        isLoading = false;
      });
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

  void _showDetailsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                  height: (18 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              const Text(
                'Short-sleeved shirt in a patterned viscose weave with a resort collar, French front and yoke at the back. '
                'Open chest pocket and slits in the sides of the hem. Relaxed Fit—a straight fit with good room for movement, '
                'creating a comfortable relaxed silhouette.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                  height: (30 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              const Text(
                'Specification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                  height: (18 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              specs('Fabric', 'Cotton'),
              specs('Length', 'Regular'),
              specs('Neck', 'Round Neck'),
              specs('Pattern', 'Graphic Print'),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewsSheet(List<Map<String, dynamic>> reviews) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Review & Rating',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        _filterBy();
                      },
                      child: filter('images/Filter.png', 'Filter'),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        _sortBy();
                      },
                      child: filter('images/sort.png', 'Sort By'),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ...reviews.map((review) {
                return reviewWidget(
                  review['rating'] ?? 0,
                  review['headline'] ?? 'No headline',
                  review['body'] ?? 'No body available',
                  review['username'] ?? 'Anonymous',
                  review['dateCreated'] ?? 'N/A',
                  review['userProfilePicture'] ?? '',
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _sortBy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
              title: Text(
            'Sort By',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
          ListTile(
            title: const Text('Most Helpful'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Most Useful'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Highest Rating'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Lowest Rating'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _filterBy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
                title: Text(
              'Filter By',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )),
            ListTile(
              title: const Text('All Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('5 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('4 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('3 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('2 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('1 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToCart(int productId, int quantity) async {
    setState(() {
      isLoading = true;
    });
    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      _showCustomSnackBar(
        context,
        'You are not logged in.',
        isError: true,
      );
      // await prefs.remove('user');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(
              key: UniqueKey(),
              onToggleDarkMode: widget.onToggleDarkMode,
              isDarkMode: widget.isDarkMode),
        ),
      );
      setState(() {
        isLoading = false;
      });
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
        _showCustomSnackBar(
          context,
          'Item added to cart successfully',
          isError: false,
        );
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to add item to cart: ${response.body}');
        _showCustomSnackBar(
          context,
          'Failed to add item to cart',
          isError: true,
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
      _showCustomSnackBar(
        context,
        'Failed to add item to cart',
        isError: true,
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        _showNoInternetDialog(context);
        setState(() {
          _isRefreshing = false;
        });
        return;
      }

      await Future.any([
        Future.delayed(const Duration(seconds: 15), () {
          throw TimeoutException('The operation took too long.');
        }),
        _fetchProductDetails(widget.itemId),
      ]);
    } catch (e) {
      if (e is TimeoutException) {
        _showTimeoutDialog(context);
      } else {
        _showErrorDialog(context, e.toString());
      }
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
            'It looks like you are not connected to the internet. Please check your connection and try again.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
                _refreshData();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTimeoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Timed Out'),
          content: const Text(
            'The operation took too long to complete. Please try again later.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
                _refreshData();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(
            'An error occurred: $error',
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: productDetails == null
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ) // Show a loader while fetching
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                  isLiked == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked == true
                                      ? Colors.red
                                      : originalIconColor),
                              onPressed: () async {
                                final previousState = isLiked;
                                setState(() {
                                  isLiked = !isLiked;
                                });

                                try {
                                  await _updateFavoriteStatus(
                                      productDetails!['id'], isLiked!);
                                } catch (error) {
                                  setState(() {
                                    isLiked =
                                        previousState; // Revert if the request fails
                                  });
                                  print(
                                      'Error updating favorite status: $error');
                                }
                              },
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.04),
                            IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: null,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            InkWell(
                              onTap: () async {
                                final String? accessToken =
                                    await storage.read(key: 'accessToken');
                                if (accessToken == null) {
                                  _showCustomSnackBar(
                                    context,
                                    'You are not logged in.',
                                    isError: true,
                                  );
                                  // await prefs.remove('user');

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInPage(
                                          key: UniqueKey(),
                                          onToggleDarkMode:
                                              widget.onToggleDarkMode,
                                          isDarkMode: widget.isDarkMode),
                                    ),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyCart(key: UniqueKey()),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/bag.png',
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: _refreshData,
                          color: Theme.of(context).colorScheme.onSurface,
                          child: ListView(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              CarouselSlider(
                                options: CarouselOptions(
                                  enlargeCenterPage: false,
                                  viewportFraction: 1.0,
                                  aspectRatio: 10 / 10,
                                  enableInfiniteScroll: false,
                                  initialPage: 0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                carouselController: _controller,
                                items: fullImgList.isNotEmpty
                                    ? fullImgList.map((item) {
                                        return Image.network(
                                          item,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                              child: Center(
                                                child: Text(
                                                  'Image not available',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList()
                                    : [
                                        Container(
                                          color: Colors.grey,
                                          child: Center(
                                            child: Text(
                                              'No images available',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.img.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Image.asset(
                                      _current == index
                                          ? "images/Elipses_active.png"
                                          : "images/Elipses.png",
                                      width: (10 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width,
                                      height: (10 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  productDetails!['name'],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  productDetails!['description'],
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/Rating Icon.png',
                                      height: 25,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Text(
                                      productDetails!['rating'],
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Text(
                                      "($totalPeopleRated)",
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Text(
                                      productDetails!['price'],
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    Text(
                                      productDetails!['slashedPrice'],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2,
                                        decorationColor: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    Text(
                                      productDetails!['discountRate'],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                        color: Color(0xFFEA580C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Color:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01),
                                        const Text(
                                          'White',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Only ${productDetails!['quantity']} Left',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    imgList(fullImgList[0]),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Size',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    Stack(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  4.0), // Adjusts the space between text and underline
                                          child: Text(
                                            'Size Chart',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width, // Match the text width or set a custom width
                                            height:
                                                2, // Thickness of the underline
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    size('S', 1),
                                    size('M', 2),
                                    size('L', 3),
                                    size('XL', 4),
                                    size('XXL', 5),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[900]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        12), // Smoother corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.2), // Softer shadow for a clean look
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(
                                            0, 2), // Position shadow for depth
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Delivery Options",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      TextFormField(
                                        controller: pinController,
                                        focusNode: _pinFocusNode,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Enter PIN Code',
                                          labelStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize: 16.0,
                                            decoration: TextDecoration.none,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xFF1D4ED8)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                width: 2, color: Colors.grey),
                                          ),
                                          suffix: const Text(
                                            'CHECK',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF1D4ED8),
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        cursorColor: const Color(0xFF1D4ED8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 16.0),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[900]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        12), // Smoother corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.2), // Softer shadow for a clean look
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(
                                            0, 2), // Position shadow for depth
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: Text(
                                          "Product Details",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      product("Fabric", "Cotton"),
                                      product("Length", "Regular"),
                                      product("Neck", "Round Neck"),
                                      product("Pattern", "Graphic Print"),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Divider(
                                          color: Colors.grey,
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: InkWell(
                                          onTap: () {
                                            _showDetailsSheet();
                                          },
                                          child: const Row(
                                            children: [
                                              Text(
                                                'View More',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.0,
                                                  color: Color(0xFF1D4ED8),
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.navigate_next,
                                                  color: Color(0xFF1D4ED8),
                                                  size: 30,
                                                ),
                                                onPressed: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 16.0),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[900]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        12), // Smoother corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.2), // Softer shadow for a clean look
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(
                                            0, 2), // Position shadow for depth
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: Text(
                                          "Ratings & Reviews",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Divider(
                                          color: Colors.grey,
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              overallRating,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 28.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            const Text(
                                              '/5',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Overall Rating',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18.0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$totalPeopleRated Ratings',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 18.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                width: double.infinity,
                                                height: (50 /
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final String? accessToken =
                                                        await storage.read(
                                                            key: 'accessToken');
                                                    if (accessToken == null) {
                                                      _showCustomSnackBar(
                                                        context,
                                                        'You are not logged in.',
                                                        isError: true,
                                                      );

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => SignInPage(
                                                              key: UniqueKey(),
                                                              onToggleDarkMode:
                                                                  widget
                                                                      .onToggleDarkMode,
                                                              isDarkMode: widget
                                                                  .isDarkMode),
                                                        ),
                                                      );
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      return;
                                                    }
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => WriteReviewPage(
                                                            key: UniqueKey(),
                                                            productId:
                                                                productDetails![
                                                                    'id'],
                                                            productImg:
                                                                fullImgList[0],
                                                            rating: int.parse(
                                                                productDetails![
                                                                    'rating'])),
                                                      ),
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<WidgetState>
                                                          states) {
                                                        if (states.contains(
                                                            WidgetState
                                                                .pressed)) {
                                                          return const Color(
                                                              0xFF1D4ED8);
                                                        }
                                                        return Colors.white;
                                                      },
                                                    ),
                                                    foregroundColor:
                                                        WidgetStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<WidgetState>
                                                          states) {
                                                        if (states.contains(
                                                            WidgetState
                                                                .pressed)) {
                                                          return Colors.white;
                                                        }
                                                        return const Color(
                                                            0xFF1D4ED8);
                                                      },
                                                    ),
                                                    elevation:
                                                        WidgetStateProperty.all<
                                                            double>(4.0),
                                                    shape: WidgetStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                      const RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 3,
                                                            color: Color(
                                                                0xFF1D4ED8)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Rate',
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Divider(
                                          color: Colors.grey,
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      if (firstReview != null) ...[
                                        // Display rating stars
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                            children: List.generate(
                                              firstReview![
                                                  'rating'], // Number of stars to display
                                              (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Image.asset(
                                                  'images/star.png',
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                          child: Text(
                                            firstReview!['headline'] ??
                                                'No headline',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                          child: Text(
                                            firstReview!['body'] ??
                                                'No review provided.',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            maxLines: 3,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 20.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: imgList(firstReview![
                                                    'userProfilePictureUrl']),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                          child: Text(
                                            "${firstReview!['username'] ?? 'Anonymous'}, ${firstReview!['dateCreated'] ?? 'N/A'}",
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            maxLines: 3,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                      ],
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Divider(
                                          color: Colors.grey,
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: InkWell(
                                          onTap: () {
                                            _showReviewsSheet(
                                                simplifiedReviews);
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'View All ${simplifiedReviews.length} Reviews',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.0,
                                                  color: Color(0xFF1D4ED8),
                                                ),
                                              ),
                                              const Spacer(),
                                              const IconButton(
                                                icon: Icon(
                                                  Icons.navigate_next,
                                                  color: Color(0xFF1D4ED8),
                                                  size: 30,
                                                ),
                                                onPressed: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'You may like',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TopCategoriesDetails(
                                              key: UniqueKey(),
                                              discountOnly: true,
                                              onToggleDarkMode:
                                                  widget.onToggleDarkMode,
                                              isDarkMode: widget.isDarkMode,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'View All',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.62,
                                  child: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        )
                                      : NotificationListener<
                                          ScrollNotification>(
                                          onNotification:
                                              (ScrollNotification scrollInfo) {
                                            if (!_isFetchingMore &&
                                                scrollInfo.metrics.pixels ==
                                                    scrollInfo.metrics
                                                        .maxScrollExtent) {
                                              // Trigger loading more products
                                              //fetchMoreProducts();
                                              return true;
                                            }
                                            return false;
                                          },
                                          child: ListView.builder(
                                            controller:
                                                _scrollController, // Attach the scroll controller
                                            scrollDirection: Axis.horizontal,
                                            itemCount: products
                                                .length, // Set to products.length, no extra item for loader
                                            itemBuilder: (context, index) {
                                              final product = products[index];
                                              List<String> imgList = [];
                                              if (product['img'] != null) {
                                                if (product['img']
                                                    is List<String>) {
                                                  imgList = List<String>.from(
                                                      product['img']);
                                                } else if (product['img']
                                                    is String) {
                                                  imgList = [product['img']];
                                                }
                                              }
                                              List<String> fullImgList =
                                                  imgList.map((img) {
                                                return '$img/download?project=677181a60009f5d039dd';
                                              }).toList();
                                              return Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                margin: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: hot(
                                                  product['id'],
                                                  product['name']!,
                                                  fullImgList,
                                                  product['details']!,
                                                  product['amount']!,
                                                  product['slashedPrice']!,
                                                  product['discount']!,
                                                  product['starImg']!,
                                                  product['rating']!,
                                                  product['rating2']!,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 5,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: (55 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                await addToCart(widget.itemId, 1);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0xFF1D4ED8);
                                    }
                                    return Colors.white;
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.white;
                                    }
                                    return const Color(0xFF1D4ED8);
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 3, color: Color(0xFF1D4ED8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                ),
                              ),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF1D4ED8),
                                      ),
                                    )
                                  : const Text(
                                      'Add to cart',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: (55 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.white;
                                    }
                                    return const Color(0xFF1D4ED8);
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0xFF1D4ED8);
                                    }
                                    return Colors.white;
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 3, color: Color(0xFF1D4ED8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Buy Now',
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget imgList(String img) {
    return img.startsWith('http')
        ? Image.network(
            img,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey, // Fallback UI if the image fails to load
              );
            },
          )
        : Image.asset(
            img,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          );
  }

  Widget size(String text, int value) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedRadioValue = value;
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: _selectedRadioValue == value
                  ? const Color(0xFF1D4ED8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 0.8,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget product(String title, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            height: 8.0,
            width: 8.0,
            decoration: const BoxDecoration(
              color: Colors.grey, // Grey color for bullet
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 4, // Adjust flex for title width distribution
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3, // Centered dash
            child: Text(
              "-",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 4, // Adjust flex for name width distribution
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hot(
      int itemId,
      String name,
      List<String> img,
      String details,
      String amount,
      String slashedPrice,
      String discount,
      String starImg,
      String rating,
      String rating2) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    bool isLiked = _isLikedMap[img[0]] ?? false;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetails(
                key: UniqueKey(),
                itemId: itemId,
                name: name,
                details: details,
                amount: amount,
                slashedPrice: slashedPrice,
                rating: rating,
                rating2: rating2,
                img: img,
                discount: discount,
                starImg: starImg,
                onToggleDarkMode: widget.onToggleDarkMode,
                isDarkMode: widget.isDarkMode),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: [
                  Image.network(
                    img[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                      ); // Fallback if image fails
                    },
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 0.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(55.0),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                            isLiked == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked == true
                                ? Colors.red
                                : originalIconColor),
                        onPressed: () {
                          setState(() {
                            _isLikedMap[img[0]] = !isLiked;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA580C),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: const Text(
                        "Top Seller",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              details,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Text(
                  slashedPrice,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 2,
                    decorationColor: Colors.grey,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Text(
                  discount,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              children: [
                Image.asset(
                  starImg,
                  height: 23,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  rating,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  rating2,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget specs(String title, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Adjust padding as needed
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3, // Adjust flex for column width distribution
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewWidget(int starNum, String title, String reviewText,
      String reviewer, String date, String img) {
    print(starNum);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: [
                ...List.generate(
                  5 - starNum,
                  (index) =>
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
                // ...List.generate(
                //   5 - starNum,
                //   (index) => const Icon(Icons.star_border,
                //       color: Colors.grey, size: 20),
                // ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              reviewText,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ),
          if (img.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: imgList(img),
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              '$reviewer, $date',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filter(String img, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          img,
          height: 22,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
