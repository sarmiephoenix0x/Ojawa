import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ojawa/faq_page.dart';
import 'package:ojawa/intro_page.dart';
import 'package:ojawa/orders_page.dart';
import 'package:ojawa/sign_in_page.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'profile_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class MainApp extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const MainApp(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<bool> _hasNotification = [false, false, false, false];
  DateTime? currentBackPressTime;
  final storage = const FlutterSecureStorage();
  int? userId;
  String? userName;
  String? _profileImage;
  String? email;
  String? state;
  String? phone;
  String? gender;
  String? role;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchUserProfile();
      }
    });
    fetchUserProfile();
  }

  Future<int?> getUserId() async {
    try {
      String? userIdString = await storage.read(key: 'userId');
      if (userIdString != null) {
        return int.tryParse(userIdString);
      }
    } catch (error) {
      print('Error retrieving userId: $error');
    }
    return null;
  }

  Future<void> fetchUserProfile() async {
    userId = await getUserId();
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Users/$userId';

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
            isLoading = false;
          });
        }
        print("Profile Loaded: ${response.body}");
        print("Profile Image URL: $_profileImage");
      } else {
        print('Error fetching profile: ${response.statusCode}');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (error) {
      print('Error: $error');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<bool> checkForToken() async {
    final accessToken = await storage.read(key: 'accessToken');
    return accessToken != null;
  }

  void _goToCategoriesPage(BuildContext context, int selectedImageIndex) {
    if (mounted) {
      setState(() {
        _selectedIndex = 1;
        _selectedImageIndex = selectedImageIndex;
      });
    }
  }

  void _goToOrdersPage(BuildContext context) {
    if (mounted) {
      setState(() {
        _selectedIndex = 2;
      });
    }
  }

  void _goToProfilePage(BuildContext context) {
    if (mounted) {
      setState(() {
        _selectedIndex = 3;
      });
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
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            _showCustomSnackBar(
              context,
              'Press back again to exit',
              isError: true,
            );
          } else {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Drawer(
                child: Container(
                  color: Colors.white, // Set your desired background color here
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color(
                              0xFFEBEDEE), // Set your desired header color here
                        ),
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 8.0),
                        child: GestureDetector(
                          onTap: () async {
                            // Check for token before navigating
                            bool tokenExists = await checkForToken();
                            Navigator.pop(
                                context); // Optional: Pop the current context if needed
                            if (tokenExists) {
                              _goToProfilePage(
                                  context); // Navigate to profile page if token exists
                            } else {
                              // Navigate to sign-in or sign-up page if token does not exist
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(
                                      key: UniqueKey(),
                                      onToggleDarkMode: widget.onToggleDarkMode,
                                      isDarkMode: widget.isDarkMode),
                                ),
                              );
                            }
                          },
                          child: Row(children: [
                            if (_profileImage == null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Container(
                                  width:
                                      (35 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (35 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  color: Colors.grey,
                                  child: Image.asset(
                                    'images/Profile.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else if (_profileImage != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Container(
                                  width:
                                      (35 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (35 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  color: Colors.grey,
                                  child: Image.network(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                      ); // Fallback if image fails
                                    },
                                  ),
                                ),
                              ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.03),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<bool>(
                                  future:
                                      checkForToken(), // Function to check for token
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(
                                          color: Colors.black);
                                    } else if (snapshot.hasData &&
                                        snapshot.data == true) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userName!,
                                            style: const TextStyle(
                                              fontFamily: 'GolosText',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            phone!, // Display phone number only if signed in
                                            style: const TextStyle(
                                              fontFamily: 'GolosText',
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const Text(
                                        "Not Signed In",
                                        style: TextStyle(
                                          fontFamily: 'GolosText',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            const IconButton(
                              icon: Icon(Icons.navigate_next,
                                  size: 30, color: Colors.black),
                              onPressed: null,
                            ),
                          ]),
                        ),
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/ShopCategories.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Shop by Categories',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _goToCategoriesPage(context, 0);
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/My Orders.png',
                          height: 25,
                        ),
                        title: const Text(
                          'My Orders',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _goToOrdersPage(context);
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/Favorite.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Favorites',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/FAQ.png',
                          height: 25,
                        ),
                        title: const Text(
                          'FAQ',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FaqPage(
                                key: UniqueKey(),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/Address.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Addresses',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                          // Navigate to home or any action you want
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/SavedCard.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Saved Cards',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/Terms.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'images/Privacy.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                        },
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.only(top: 16, left: 16),
                        leading: Image.asset(
                          'images/Logout.png',
                          height: 25,
                        ),
                        title: const Text(
                          'Log out',
                          style: TextStyle(
                            fontFamily: 'GolosText',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showLogoutConfirmationDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(
                selectedIndex: _selectedIndex,
                onToggleDarkMode: widget.onToggleDarkMode,
                isDarkMode: widget.isDarkMode,
                goToCategoriesPage: _goToCategoriesPage,
                goToOrdersPage: _goToOrdersPage,
                goToProfilePage: _goToProfilePage,
                scaffoldKey: _scaffoldKey,
              ),
              CategoriesPage(
                goToCategoriesPage: _goToCategoriesPage,
                goToOrdersPage: _goToOrdersPage,
                goToProfilePage: _goToProfilePage,
                scaffoldKey: _scaffoldKey,
                selectedImageIndex: _selectedImageIndex,
                onToggleDarkMode: widget.onToggleDarkMode,
                isDarkMode: widget.isDarkMode,
              ),
              OrdersPage(
                  goToCategoriesPage: _goToCategoriesPage,
                  goToOrdersPage: _goToOrdersPage,
                  goToProfilePage: _goToProfilePage,
                  scaffoldKey: _scaffoldKey,
                  onToggleDarkMode: widget.onToggleDarkMode,
                  isDarkMode: widget.isDarkMode),
              ProfilePage(
                goToCategoriesPage: _goToCategoriesPage,
                goToOrdersPage: _goToOrdersPage,
                goToProfilePage: _goToProfilePage,
                scaffoldKey: _scaffoldKey,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Home_active.png'),
                color: Colors.grey,
              ),
              label: 'Home',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Home_active.png')),
                  if (_hasNotification[0])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Categories.png'),
                color: Colors.grey,
              ),
              label: 'Categories',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Categories.png')),
                  if (_hasNotification[1])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Orders.png'),
                color: Colors.grey,
              ),
              label: 'Orders',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Orders.png')),
                  if (_hasNotification[2])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Profile.png'),
                color: Colors.grey,
              ),
              label: 'Profile',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Profile.png')),
                  if (_hasNotification[3])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: (index) async {
            if (index != _selectedIndex) {
              if (index != 3) {
                setState(() {
                  _selectedIndex = index;
                });
              } else {
                bool tokenExists = await checkForToken();

                if (tokenExists == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPage(
                          key: UniqueKey(),
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode),
                    ),
                  );
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              }
            }
          },
        ),
      ),
    );
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
}
