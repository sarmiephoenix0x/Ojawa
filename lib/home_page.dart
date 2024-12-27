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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
    _remainingTime =
        11 * 3600 + 15 * 60 + 4; // Example: 11 hours, 15 minutes, 4 seconds
    _startTimer();
    _initializePrefs();
    fetchUserProfile();
    fetchProducts();
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

  Future<void> fetchProducts() async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products';

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
      // _showCustomSnackBar(
      //   context,
      //   'Response Data: $responseData',
      //   isError: true,
      // );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          products = responseData.map((product) {
            return {
              'img': product['productImageUrl'],
              'details': product['description'],
              'amount': '\$${product['price']}',
              'slashedPrice':
                  product['hasDiscount'] ? '\$${product['discountPrice']}' : '',
              'discount': product['hasDiscount']
                  ? '${product['discountRate']}% OFF'
                  : '',
              'starImg':
                  'images/Rating Icon.png', // Assuming a static image for rating
              'rating': product['rating'].toString(),
              'rating2': '(0)', // Placeholder for review count
            };
          }).toList();
        });
      } else {
        // _showCustomSnackBar(
        //   context,
        //   'Error fetching products: ${response.statusCode}',
        //   isError: true,
        // );
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
                    onTap: () {
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'View All',
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
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            category('images/Fashion.png', 'Fashion'),
                            category('images/Electronics.png', 'Electronics'),
                            category('images/Appliances.png', 'Appliances'),
                            category('images/Beauty.png', 'Beauty'),
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
                              width: (10 / MediaQuery.of(context).size.width) *
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
                                  const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      color: Colors.grey,
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: products.map((product) {
                                    return deal(
                                      product[
                                          'img'], // Assuming 'img' is the URL of the product image
                                      product['details'], // Product details
                                      product['discount'], // Discount text
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'View All',
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
                          child: ListView.builder(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Container(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Set a fixed width for each item
                                margin: const EdgeInsets.only(
                                    right: 20.0), // Space between items
                                child: hot(
                                  product['img']!,
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'View All',
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
                          child: ListView.builder(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Container(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Set a fixed width for each item
                                margin: const EdgeInsets.only(
                                    right: 20.0), // Space between items
                                child: hot(
                                  product['img']!,
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
                    ],
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

  Widget deal(String img, String text, String text2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Productdetails(key: UniqueKey()),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                img,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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

  Widget hot(String img, String details, String amount, String slashedPrice,
      String discount, String starImg, String rating, String rating2) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    bool isLiked = _isLikedMap[img] ?? false;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetails(key: UniqueKey()),
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
                  Image.asset(
                    img,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 5,
                    right: MediaQuery.of(context).padding.right + 5,
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
                            _isLikedMap[img] = !isLiked;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 5,
                    left: MediaQuery.of(context).padding.left + 5,
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
