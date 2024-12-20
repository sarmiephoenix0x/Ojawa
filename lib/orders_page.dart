import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ojawa/faq_page.dart';
import 'package:ojawa/order_details.dart';

class OrdersPage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  const OrdersPage(
      {super.key,
      required this.goToOrdersPage,
      required this.goToCategoriesPage,
      required this.goToProfilePage});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List searchResults = [];
  bool searchLoading = false;
  bool _isSearching = false;
  final storage = const FlutterSecureStorage();
  int? _selectedRadioValue;
  int? _selectedRadioValue2;
  String? userName;
  String? profileImg;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _filterBy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filter',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Status Type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  ListTile(
                    title: filter("Upcoming", 1, setState),
                    onTap: null,
                  ),
                  ListTile(
                    title: filter("Cancelled", 2, setState),
                    onTap: null,
                  ),
                  ListTile(
                    title: filter("Delivered", 3, setState),
                    onTap: null,
                  ),
                  const Divider(), // Divider between the two sections
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filter Time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  ListTile(
                    title: filter2("Last 30 Days", 1, setState),
                    onTap: null,
                  ),
                  ListTile(
                    title: filter2("6 Months", 2, setState),
                    onTap: null,
                  ),
                  ListTile(
                    title: filter2("2024", 3, setState),
                    onTap: null,
                  ),
                  ListTile(
                    title: filter2("2023", 4, setState),
                    onTap: null,
                  ),
                  SizedBox(
                      height: (28 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      height: (60 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Apply Filter',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _trackOrder() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Track Order',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    _buildOrderStep(
                      timeStamp: "10:30 AM",
                      title: "Order Confirmed",
                      subText: "Your order has been confirmed",
                      isCompleted: true,
                    ),
                    _buildConnectingLine(isCompleted: true),
                    _buildOrderStep(
                      timeStamp: "01:00 PM",
                      title: "Order Shipped",
                      subText: "Order shipped from [destination]",
                      isCompleted: true,
                    ),
                    _buildConnectingLine(isCompleted: false),
                    _buildOrderStep(
                      timeStamp: "",
                      title: "Out for Delivery",
                      subText: "",
                      isCompleted: false,
                    ),
                    _buildConnectingLine(isCompleted: false),
                    _buildOrderStep(
                      timeStamp: "",
                      title: "Order Delivered",
                      subText: "",
                      isCompleted: false,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          widget.goToProfilePage(context);
                        },
                        child: Row(children: [
                          if (profileImg == null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Container(
                                width:
                                    (35 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (35 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                color: Colors.grey,
                                child: Image.asset(
                                  'images/Profile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else if (profileImg != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Container(
                                width:
                                    (35 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (35 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                color: Colors.grey,
                                child: Image.network(
                                  profileImg!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // if (userName != null)
                              //   Text(
                              //     userName!,
                              //     style: const TextStyle(
                              //       fontFamily: 'GolosText',
                              //       fontSize: 16.0,
                              //       fontWeight: FontWeight.bold,
                              //       color:Colors.black
                              //     ),
                              //   )
                              // else
                              //   const CircularProgressIndicator(color: Colors.black),
                              Text(
                                "Philip",
                                style: TextStyle(
                                    fontFamily: 'GolosText',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                "+2349016482578",
                                style: TextStyle(
                                    fontFamily: 'GolosText',
                                    fontSize: 16.0,
                                    color: Colors.black),
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
                        widget.goToCategoriesPage(context);
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
                        widget.goToOrdersPage(context);
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
                      contentPadding: const EdgeInsets.only(top: 16, left: 16),
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
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        const Text('Orders', style: TextStyle(fontSize: 20)),
                        const Spacer(),
                        Container(
                          height: (40 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _filterBy();
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
                                      width: 2, color: Color(0xFF1D4ED8)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/sort.png',
                                  height: 22,
                                  color: const Color(0xFF1D4ED8),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                const Text(
                                  "Filter",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    color: Color(0xFF1D4ED8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    labelText: 'Search Order',
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/NoOrderFound.png',
                              height: 200,
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'No Orders Found!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(113, 0, 0, 0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Currently, you do not have any orders. When you order something, it will appear here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(113, 0, 0, 0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                width: double.infinity,
                                height:
                                    (60 / MediaQuery.of(context).size.height) *
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Start Shopping',
                                    style: TextStyle(
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
                    ),
                  ]
                ]
              ] else ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        order(
                            'images/OrderReceived.png',
                            'Order Received',
                            '21st December, 2024',
                            "images/Img4.png",
                            "Allen Solly Regular fit cotton shirt",
                            "L",
                            "Black"),
                        order(
                            'images/OrderCancelled.png',
                            'Order Cancelled',
                            '21st December, 2024',
                            "images/Img4.png",
                            "Allen Solly Regular fit cotton shirt",
                            "L",
                            "Black"),
                        order(
                            'images/OrderDelivered.png',
                            'Order Deleivered',
                            '21st December, 2024',
                            "images/Img4.png",
                            "Allen Solly Regular fit cotton shirt",
                            "L",
                            "Black"),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget order(String img, String type, String date, String prodImg,
      String prodDetails, String prodSize, String prodColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.2), // Softer shadow for a clean look
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2), // Position shadow for depth
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetails(
                          key: UniqueKey(),
                          goToOrdersPage: widget.goToOrdersPage),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      img,
                      height: 30,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetails(
                                key: UniqueKey(),
                                goToOrdersPage: widget.goToOrdersPage),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      prodImg,
                      width: 100,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                      width: (16.0 / MediaQuery.of(context).size.width) *
                          MediaQuery.of(context).size.width),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            prodDetails,
                            softWrap: true,
                            style: const TextStyle(fontSize: 16.0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Size:",
                                    style: TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      width: (6.0 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width),
                                  Text(
                                    prodSize,
                                    style: const TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(
                                  width: (20.0 /
                                          MediaQuery.of(context).size.width) *
                                      MediaQuery.of(context).size.width),
                              Row(
                                children: [
                                  const Text(
                                    "Color:",
                                    style: TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                      width: (6.0 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width),
                                  Text(
                                    prodColor,
                                    style: const TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      height: (50 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Theme.of(context).colorScheme.onSurface;
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
                              return Theme.of(context).colorScheme.onSurface;
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      height: (50 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _trackOrder();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Theme.of(context).colorScheme.onSurface;
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
                              return Theme.of(context).colorScheme.onSurface;
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Track',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.0,
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

  Widget filter(String text, int value, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRadioValue = value; // Update selected value
          });
        },
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: _selectedRadioValue == value ? 3 : 0.8,
                  color: _selectedRadioValue == value
                      ? const Color(0xFF1D4ED8)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filter2(String text, int value, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRadioValue2 = value; // Update selected value
          });
        },
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: _selectedRadioValue2 == value ? 3 : 0.8,
                  color: _selectedRadioValue2 == value
                      ? const Color(0xFF1D4ED8)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStep({
    required String timeStamp,
    required String title,
    required String subText,
    required bool isCompleted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column for vertical alignment
          if (timeStamp.isNotEmpty) ...[
            Text(
              timeStamp,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ] else ...[
            SizedBox(width: MediaQuery.of(context).size.width * 0.145),
          ],
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),

          Icon(
            Icons.check_circle,
            color: isCompleted ? Colors.blue : Colors.grey,
            size: 24,
          ),

          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          // Title and subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: isCompleted ? Colors.black : Colors.grey,
                  ),
                ),
                if (subText.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    subText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLine({required bool isCompleted}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 40, // Height of the line
          width: 2,
          color: isCompleted ? Colors.blue : Colors.grey,
          margin: const EdgeInsets.only(left: 74.0), // Align with ticks
        ));
  }
}
