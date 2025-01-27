import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ojawa/faq_page.dart';
import 'package:ojawa/intro_page.dart';
import 'package:ojawa/my_cart.dart';
import 'package:ojawa/productDetails.dart';
import 'package:ojawa/sign_in_page.dart';
import 'package:ojawa/top_categories_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage(
      {super.key,
      required this.selectedIndex,
      required this.onToggleDarkMode,
      required this.isDarkMode,
      required this.goToOrdersPage,
      required this.goToCategoriesPage,
      required this.goToProfilePage,
      required this.scaffoldKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RouteAware {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List searchResults = [];
  bool searchLoading = false;
  bool _isSearching = false;
  List<String> imagePaths = [
    "images/Banner.png",
    "images/Banner.png",
    "images/Banner.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  Map<String, bool> _isLikedMap = {};
  int? _selectedRadioValue;
  final storage = const FlutterSecureStorage();
  ValueNotifier<String?> _selectedFilter = ValueNotifier<String?>(null);
  bool isFilterActive = false;
  int? userId;
  String? userName;
  String? _profileImage;
  String? email;
  String? state;
  String? phone;
  String? gender;
  String? role;
  // final List<Map<String, String>> products = [
  //   {
  //     'img': 'images/Img2.png',
  //     'details': 'Allen Solly Regular fit cotton shirt',
  //     'amount': '\$35',
  //     'slashedPrice': '\$40.25',
  //     'discount': '15% OFF',
  //     'starImg': 'images/Rating Icon.png',
  //     'rating': '4.4',
  //     'rating2': '(412)',
  //   },

  //   {
  //     'img': 'images/Img2.png',
  //     'details': 'Allen Solly Regular fit cotton shirt',
  //     'amount': '\$35',
  //     'slashedPrice': '\$40.25',
  //     'discount': '15% OFF',
  //     'starImg': 'images/Rating Icon.png',
  //     'rating': '4.4',
  //     'rating2': '(412)',
  //   },
  //   {
  //     'img': 'images/Img2.png',
  //     'details': 'Allen Solly Regular fit cotton shirt',
  //     'amount': '\$35',
  //     'slashedPrice': '\$40.25',
  //     'discount': '15% OFF',
  //     'starImg': 'images/Rating Icon.png',
  //     'rating': '4.4',
  //     'rating2': '(412)',
  //   },
  //   {
  //     'img': 'images/Img2.png',
  //     'details': 'Allen Solly Regular fit cotton shirt',
  //     'amount': '\$35',
  //     'slashedPrice': '\$40.25',
  //     'discount': '15% OFF',
  //     'starImg': 'images/Rating Icon.png',
  //     'rating': '4.4',
  //     'rating2': '(412)',
  //   },
  //   // Add more products here
  // ];
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;
  late SharedPreferences prefs;
  Timer? _timer;
  int _remainingTime = 0;
  bool _isLoading = false;
  bool _isRefreshing = false;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int pageNum = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        //fetchUserProfile();
        if (products.isEmpty) {
          fetchProducts(overwrite: true);
        }
      }
    });
    _remainingTime =
        11 * 3600 + 15 * 60 + 4; // Example: 11 hours, 15 minutes, 4 seconds
    _startTimer();
    _initializePrefs();
    // fetchUserProfile();
    fetchProducts(overwrite: true);
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> checkForToken() async {
    // Read the access token from secure storage
    final accessToken = await storage.read(key: 'accessToken');
    return accessToken != null; // Check if token exists
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel(); // Stop the timer when it reaches zero
      }
    });
  }

  void _onScroll() {
    //if (_scrollController.position.pixels >=
    //         _scrollController.position.maxScrollExtent &&
    //     !_isLoading &&
    //     !_isFetchingMore) {
    //   fetchMoreProducts(); // Trigger fetching more products
    // }
  }

  void _showResponseDialog(BuildContext context, dynamic responseData) {
    // Convert the response data to a JSON string with indentation
    final String prettyJson =
        const JsonEncoder.withIndent('  ').convert(responseData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Response Data'),
          content: Container(
            width:
                double.maxFinite, // Ensure the dialog takes up available space
            child: SingleChildScrollView(
              child: Text(prettyJson),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchProducts({bool overwrite = false}) async {
    // Prevent multiple fetches by checking `_isLoading`
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    if (overwrite) {
      // Clear the existing products if overwriting
      products.clear();
      pageNum = 1; // Reset to the first page
    }

    await _fetchProductsForPage(pageNum);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMoreProducts() async {
    if (_isFetchingMore) return; // Prevent multiple fetches

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
        print('Response Data: $responseData');
        //_showResponseDialog(context, responseData);
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
              'isInFavorite': product['isInFavorite'] ?? false,
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

  Future<int?> getUserId() async {
    try {
      // Retrieve the userId from storage
      String? userIdString =
          await storage.read(key: 'userId'); // Use the correct key for userId
      if (userIdString != null) {
        return int.tryParse(userIdString); // Convert the string to an integer
      }
    } catch (error) {
      print('Error retrieving userId: $error');
    }
    return null; // Return null if userId is not found or an error occurs
  }

  Future<void> fetchUserProfile() async {
    // Retrieve the userId from storage
    userId =
        await getUserId(); // Assuming this retrieves the userId from Flutter Secure Storage
    final String? accessToken = await storage.read(
        key: 'accessToken'); // Use the correct key for access token
    final url =
        'https://ojawa-api.onrender.com/api/Users/$userId'; // Update the URL to the correct endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            // Access the user data from the nested "data" key
            final userData = responseData['data'];
            userName = userData['username'];
            email = userData['email'];
            state = userData['state'];
            phone = userData['phone'];
            gender = userData['gender'];
            role = userData['role'];
            final profilePictureUrl =
                userData['profilePictureUrl']?.toString().trim();

            _profileImage =
                (profilePictureUrl != null && profilePictureUrl.isNotEmpty)
                    ? '$profilePictureUrl/download?project=66e4476900275deffed4'
                    : '';
            isLoading = false; // Set loading to false after data is fetched
          });
        }
        print("Profile Loaded: ${response.body}");
        print("Profile Image URL: $_profileImage");
      } else {
        print('Error fetching profile: ${response.statusCode}');
        if (mounted) {
          setState(() {
            isLoading = false; // Set loading to false on error
          });
        }
      }
    } catch (error) {
      print('Error: $error');
      if (mounted) {
        setState(() {
          isLoading = false; // Set loading to false on exception
        });
      }
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      searchLoading = true;
    });
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://signal.payguru.com.ng/api/search?query=$query';
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // Perform GET request
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        searchResults = jsonDecode(response.body);
        searchLoading = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        searchResults = [];
        searchLoading = false;
      });
      _showCustomSnackBar(
        context,
        'No results found for the query.',
        isError: true,
      );
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      setState(() {
        searchResults = [];
        searchLoading = false;
      });
      final errorMessage = jsonDecode(response.body)['message'];
      _showCustomSnackBar(
        context,
        errorMessage,
        isError: true,
      );
    }
  }

  Future<void> _logout() async {
    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      _showCustomSnackBar(
        context,
        'You are not logged in.',
        isError: true,
      );
      // await prefs.remove('user');

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const IntroPage(),
      //   ),
      // );
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      return;
    }

    await storage.delete(key: 'accessToken');
    // await prefs.remove('user');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IntroPage(
            key: UniqueKey(),
            onToggleDarkMode: widget.onToggleDarkMode,
            isDarkMode: widget.isDarkMode),
      ),
    );
    setState(() {
      isLoading = false;
    });
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

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to log out?'),
              actions: <Widget>[
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontFamily: 'Inter'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                    ),
                    const Spacer(),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          _logout().then((_) {
                            // Navigator.of(context)
                            //     .pop(); // Dismiss dialog after logout
                          }).catchError((error) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: 'Inter'),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
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
        fetchProducts(overwrite: true),
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
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int hours = (_remainingTime ~/ 3600);
    int minutes = (_remainingTime % 3600) ~/ 60;
    int seconds = _remainingTime % 60;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: _isSearching
            ? Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isSearching = false;
                          searchController.clear();
                        });
                      },
                      child: Image.asset(
                        'images/Back.png',
                        height: 55,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )
            : Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      widget.scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'images/notification.png',
                    height: 22,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
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
                                onToggleDarkMode: widget.onToggleDarkMode,
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
                          builder: (context) => MyCart(key: UniqueKey()),
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: searchController,
                  focusNode: _searchFocusNode,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: 'What are you looking for?',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF008000)),
                      onPressed: () {
                        if (searchController.text.isNotEmpty) {
                          _performSearch(searchController.text.trim());
                        }
                      },
                    ),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: Icon(Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface), // White close icon
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                searchController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  onChanged: (value) {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              ),
              if (_isSearching) ...[
                if (searchLoading) ...[
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onSurface,
                      ), // Use primary color
                      strokeWidth: 4.0,
                    ),
                  )
                ] else ...[
                  if (searchResults.isNotEmpty) ...[
                    ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            searchResults[index]['title'] ?? 'No Title',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            searchResults[index]['description'] ??
                                'No Description',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    )
                  ] else ...[
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/NotFound.png',
                                height: 300,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No results to display',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                ]
              ] else ...[
                Flexible(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    color: Theme.of(context).colorScheme.onSurface,
                    child: ListView(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  widget.goToCategoriesPage(context, 0);
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
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  widget.goToCategoriesPage(context, 0);
                                },
                                child:
                                    category('images/Fashion.png', 'Fashion'),
                              ),
                              InkWell(
                                onTap: () {
                                  widget.goToCategoriesPage(context, 1);
                                },
                                child: category(
                                    'images/Electronics.png', 'Electronics'),
                              ),
                              InkWell(
                                onTap: () {
                                  widget.goToCategoriesPage(context, 2);
                                },
                                child: category(
                                    'images/Appliances.png', 'Appliances'),
                              ),
                              InkWell(
                                onTap: () {
                                  widget.goToCategoriesPage(context, 3);
                                },
                                child: category('images/Beauty.png', 'Beauty'),
                              ),
                              // category('images/Furniture.png', 'Furniture'),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              enlargeCenterPage: false,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: false,
                              initialPage: 0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            carouselController: _controller,
                            items: imagePaths.map((item) {
                              return Image.asset(
                                item,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imagePaths.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.asset(
                                _current == index
                                    ? "images/Elipses_active.png"
                                    : "images/Elipses.png",
                                width:
                                    (10 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (10 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 10.0),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEBEDEE),
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Deal of the day',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
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
                                                    isDarkMode:
                                                        widget.isDarkMode),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'View All',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      time(hours, minutes, seconds),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                // Container(
                                //   width: MediaQuery.of(context).size.width,
                                //   padding: const EdgeInsets.symmetric(
                                //       vertical: 16.0, horizontal: 10.0),
                                //   decoration: const BoxDecoration(
                                //     color: Color(0xFFFFFFFF),
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(5.0),
                                //     ),
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       deal('images/Img1.png', 'Running shoes',
                                //           'Upto 40% OFF'),
                                //       deal('images/Img2.png', 'Sneakers',
                                //           '40-60% OFF'),
                                //       deal('images/Img3.png', 'Wrist Watches',
                                //           'Upto 40% OFF'),
                                //       deal('images/Img4.png',
                                //           'Bluetooth Speakers', '40-60% OFF'),
                                //     ],
                                //   ),
                                // ),

                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: _isLoading // Check if loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ) // Show loader while loading
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: products
                                              .where((product) =>
                                                  product['hasDiscount'] ==
                                                  true) // Keep this line
                                              .map((product) {
                                            List<String> imgList = [];

                                            // Check if product['img'] is not null
                                            if (product['img'] != null) {
                                              if (product['img']
                                                  is List<String>) {
                                                // If it's already a List<String>, use it directly
                                                imgList = List<String>.from(
                                                    product['img']);
                                              } else if (product['img']
                                                  is String) {
                                                // If it's a String, convert it to a List<String>
                                                imgList = [
                                                  product['img']
                                                ]; // Create a list with the single image
                                              }
                                            }

                                            // Append the download string to each image URL in imgList
                                            List<String> fullImgList =
                                                imgList.map((img) {
                                              return '$img/download?project=677181a60009f5d039dd';
                                            }).toList();
                                            return deal(
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
                                              product[
                                                  'uptoDiscount'], // Discount text
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Hot Selling Footwear',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                              discountOnly: false,
                                              onToggleDarkMode:
                                                  widget.onToggleDarkMode,
                                              isDarkMode: widget.isDarkMode),
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
                            height: MediaQuery.of(context).size.height * 0.03),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       hot(
                        //           'images/Img1.png',
                        //           'Adidas white sneakers for men',
                        //           '\$68',
                        //           '\$136',
                        //           '50% OFF',
                        //           'images/Rating Icon.png',
                        //           '4.8',
                        //           '(692)'),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.62,
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  )
                                : NotificationListener<ScrollNotification>(
                                    onNotification:
                                        (ScrollNotification scrollInfo) {
                                      if (!_isFetchingMore &&
                                          scrollInfo.metrics.pixels ==
                                              scrollInfo
                                                  .metrics.maxScrollExtent) {
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
                                          .length, // Set to products.length
                                      itemBuilder: (context, index) {
                                        final product = products[
                                            index]; // Access product safely
                                        List<String> imgList = [];
                                        if (product['img'] != null) {
                                          if (product['img'] is List<String>) {
                                            imgList = List<String>.from(
                                                product['img']);
                                          } else if (product['img'] is String) {
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
                                          child: Hot(
                                            itemId: product['id'],
                                            name: product['name']!,
                                            img: fullImgList,
                                            details: product['details']!,
                                            amount: product['amount']!,
                                            slashedPrice:
                                                product['slashedPrice']!,
                                            discount: product['discount']!,
                                            starImg: product['starImg']!,
                                            rating: product['rating']!,
                                            rating2: product['rating2']!,
                                            liked: product['isInFavorite'],
                                            onToggleDarkMode:
                                                widget.onToggleDarkMode,
                                            isDarkMode: widget.isDarkMode,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Recommended for you',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                              discountOnly: false,
                                              onToggleDarkMode:
                                                  widget.onToggleDarkMode,
                                              isDarkMode: widget.isDarkMode),
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
                            height: MediaQuery.of(context).size.height * 0.03),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       hot(
                        //           'images/Img2.png',
                        //           'Allen Solly Regular fit cotton shirt',
                        //           '\$35',
                        //           '\$40.25',
                        //           '15% OFF',
                        //           'images/Rating Icon.png',
                        //           '4.4',
                        //           '(412)'),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.62,
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  )
                                : NotificationListener<ScrollNotification>(
                                    onNotification:
                                        (ScrollNotification scrollInfo) {
                                      if (!_isFetchingMore &&
                                          scrollInfo.metrics.pixels ==
                                              scrollInfo
                                                  .metrics.maxScrollExtent) {
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
                                        final product = products[
                                            index]; // Access product at current index
                                        List<String> imgList = [];
                                        if (product['img'] != null) {
                                          if (product['img'] is List<String>) {
                                            imgList = List<String>.from(
                                                product['img']);
                                          } else if (product['img'] is String) {
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
                                          child: Hot(
                                            itemId: product['id'],
                                            name: product['name']!,
                                            img: fullImgList,
                                            details: product['details']!,
                                            amount: product['amount']!,
                                            slashedPrice:
                                                product['slashedPrice']!,
                                            discount: product['discount']!,
                                            starImg: product['starImg']!,
                                            rating: product['rating']!,
                                            rating2: product['rating2']!,
                                            liked: product['isInFavorite'],
                                            onToggleDarkMode:
                                                widget.onToggleDarkMode,
                                            isDarkMode: widget.isDarkMode,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (searchResults.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(0.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFilterActive = true;
                      });
                    },
                    child: filter('images/Filter.png', 'Filter'),
                  ),
                  InkWell(
                    onTap: () {
                      _sortBy();
                    },
                    child: filter('images/sort.png', 'Sort By'),
                  ),
                ],
              ),
            ),
          if (isFilterActive)
            Positioned.fill(
              child: Container(
                color: const Color(0xFFFFFFFF),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        setState(() {
                                          isFilterActive = false;
                                        });
                                      });
                                    },
                                    child: Image.asset(
                                      'images/Cancel.png',
                                      height: 30,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Text(
                                'CLEAR ALL',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width:
                                    (150 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (440 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 0.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF808080),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      list('Brand', 1),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      list('Size', 2),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      list('Category', 3),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      list('Bundles', 4),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      list('Price Range', 5),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      list('Discount', 6),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      list('Rating', 7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            SizedBox(
                              height:
                                  (440 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    filterOption("S"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("ML"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("XL"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("XXL"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("3XL"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("4XL"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("5XL"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("6XL"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    filterOption("7XL"),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                              height:
                                  (55 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFF1D4ED8);
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return Colors.white;
                                      }
                                      return const Color(0xFF1D4ED8);
                                    },
                                  ),
                                  elevation:
                                      WidgetStateProperty.all<double>(4.0),
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
                                  'Clear All',
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
                              height:
                                  (55 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return Colors.white;
                                      }
                                      return const Color(0xFF1D4ED8);
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFF1D4ED8);
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  elevation:
                                      WidgetStateProperty.all<double>(4.0),
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
                                  'View 12 Results',
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
            ),
        ],
      ),
    );
  }

  Widget category(String img, String text) {
    return Column(
      children: [
        Image.asset(
          img,
          height: 55,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
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

  Widget time(int hours, int minutes, int seconds) {
    return Row(
      children: [
        Text(
          hours.toString().padLeft(2, '0'), // Format to 2 digits
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Text(
          'HRS',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        Text(
          minutes.toString().padLeft(2, '0'), // Format to 2 digits
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Text(
          'MIN',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        Text(
          seconds.toString().padLeft(2, '0'), // Format to 2 digits
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Text(
          'SEC',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget deal(
      int itemId,
      String name,
      List<String> img,
      String details,
      String amount,
      String slashedPrice,
      String discount,
      String starImg,
      String rating,
      String rating2,
      String text2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: InkWell(
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
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                img[0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                  ); // Fallback if image fails
                },
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                text2,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hot(
  //     int itemId,
  //     String name,
  //     List<String> img,
  //     String details,
  //     String amount,
  //     String slashedPrice,
  //     String discount,
  //     String starImg,
  //     String rating,
  //     String rating2,
  //     bool liked) {
  //   Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
  //   //bool isLiked = liked;

  //   ValueNotifier<bool> isLikedNotifier;
  //   isLikedNotifier = ValueNotifier<bool>(liked);
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Productdetails(
  //               key: UniqueKey(),
  //               itemId: itemId,
  //               name: name,
  //               details: details,
  //               amount: amount,
  //               slashedPrice: slashedPrice,
  //               rating: rating,
  //               rating2: rating2,
  //               img: img,
  //               discount: discount,
  //               starImg: starImg,
  //               onToggleDarkMode: widget.onToggleDarkMode,
  //               isDarkMode: widget.isDarkMode),
  //         ),
  //       );
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 40.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(5),
  //             child: Stack(
  //               children: [
  //                 Image.network(
  //                   img[0],
  //                   fit: BoxFit.cover,
  //                   errorBuilder: (context, error, stackTrace) {
  //                     return Container(
  //                       color: Colors.grey,
  //                     ); // Fallback if image fails
  //                   },
  //                 ),
  //                 Positioned(
  //                   top: MediaQuery.of(context).padding.top + 5,
  //                   right: MediaQuery.of(context).padding.right + 5,
  //                   child: ValueListenableBuilder<bool>(
  //                     valueListenable: isLikedNotifier,
  //                     builder: (context, isLiked, child) {
  //                       return Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 0.0, horizontal: 0.0),
  //                         decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.all(
  //                             Radius.circular(55.0),
  //                           ),
  //                         ),
  //                         child: IconButton(
  //                           icon: Icon(
  //                             isLiked ? Icons.favorite : Icons.favorite_border,
  //                             color: isLiked ? Colors.red : originalIconColor,
  //                           ),
  //                           onPressed: () async {
  //                             final previousState = isLiked;
  //                             isLikedNotifier.value = !isLiked;
  //                             try {
  //                               await _updateFavoriteStatus(
  //                                   itemId, isLikedNotifier.value);
  //                             } catch (error) {
  //                               isLikedNotifier.value =
  //                                   previousState; // Revert if the request fails
  //                               print('Error updating favorite status: $error');
  //                             }
  //                           },
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: MediaQuery.of(context).padding.top + 5,
  //                   left: MediaQuery.of(context).padding.left + 5,
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 6.0, horizontal: 10.0),
  //                     decoration: const BoxDecoration(
  //                       color: Color(0xFFEA580C),
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(5.0),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       "Top Seller",
  //                       style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 14.0,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
  //           Text(
  //             details,
  //             style: TextStyle(
  //               fontFamily: 'Poppins',
  //               fontSize: 16.0,
  //               color: Theme.of(context).colorScheme.onSurface,
  //             ),
  //           ),
  //           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
  //           Row(
  //             children: [
  //               Text(
  //                 amount,
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Theme.of(context).colorScheme.onSurface,
  //                 ),
  //               ),
  //               SizedBox(width: MediaQuery.of(context).size.width * 0.03),
  //               Text(
  //                 slashedPrice,
  //                 style: const TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 14.0,
  //                   color: Colors.grey,
  //                   decoration: TextDecoration.lineThrough,
  //                   decorationThickness: 2,
  //                   decorationColor: Colors.grey,
  //                 ),
  //               ),
  //               SizedBox(width: MediaQuery.of(context).size.width * 0.03),
  //               Text(
  //                 discount,
  //                 style: const TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 14.0,
  //                   color: Color(0xFFEA580C),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
  //           Row(
  //             children: [
  //               Image.asset(
  //                 starImg,
  //                 height: 23,
  //               ),
  //               SizedBox(width: MediaQuery.of(context).size.width * 0.02),
  //               Text(
  //                 rating,
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 16.0,
  //                   color: Theme.of(context).colorScheme.onSurface,
  //                 ),
  //               ),
  //               SizedBox(width: MediaQuery.of(context).size.width * 0.02),
  //               Text(
  //                 rating2,
  //                 style: const TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 16.0,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          ListTile(
            title: const Text('Price - High to Low'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Price - Low to High'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Popularity'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Discount'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Customer Rating'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget list(String text, int value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRadioValue = value;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: _selectedRadioValue == value
              ? const Color(0xFFFFFFFF)
              : Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(0.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget filterOption(String text) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedFilter,
      builder: (context, selectedOption, child) {
        bool isChecked = selectedOption == text;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              activeColor: const Color(0xFF008000),
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (bool? value) {
                // Toggle the checkbox for the current option
                if (value == true) {
                  // Set this option as selected, unchecking others
                  _selectedFilter.value = text;
                } else {
                  // Deselect the option
                  _selectedFilter.value = null;
                }
              },
            ),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Poppins',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Hot extends StatefulWidget {
  final int itemId;
  final String name;
  final List<String> img;
  final String details;
  final String amount;
  final String slashedPrice;
  final String discount;
  final String starImg;
  final String rating;
  final String rating2;
  final bool liked;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const Hot({
    Key? key,
    required this.itemId,
    required this.name,
    required this.img,
    required this.details,
    required this.amount,
    required this.slashedPrice,
    required this.discount,
    required this.starImg,
    required this.rating,
    required this.rating2,
    required this.liked,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _HotWidgetState createState() => _HotWidgetState();
}

class _HotWidgetState extends State<Hot> {
  late ValueNotifier<bool> isLikedNotifier;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    isLikedNotifier = ValueNotifier<bool>(widget.liked);
  }

  @override
  void dispose() {
    isLikedNotifier.dispose();
    super.dispose();
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetails(
                key: UniqueKey(),
                itemId: widget.itemId,
                name: widget.name,
                details: widget.details,
                amount: widget.amount,
                slashedPrice: widget.slashedPrice,
                rating: widget.rating,
                rating2: widget.rating2,
                img: widget.img,
                discount: widget.discount,
                starImg: widget.starImg,
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
                    widget.img[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey);
                    },
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLikedNotifier,
                      builder: (context, isLiked, child) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(55.0)),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              final previousState = isLiked;
                              try {
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
                                  return;
                                }
                                isLikedNotifier.value = !isLiked;
                                await _updateFavoriteStatus(
                                    widget.itemId, isLikedNotifier.value);
                              } catch (error) {
                                isLikedNotifier.value = previousState;
                                print('Error updating favorite status: $error');
                              }
                            },
                          ),
                        );
                      },
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
              widget.details,
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
                  widget.amount,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Text(
                  widget.slashedPrice,
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
                  widget.discount,
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
                  widget.starImg,
                  height: 23,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  widget.rating,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  widget.rating2,
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
}
