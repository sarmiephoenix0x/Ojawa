import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ojawa/edit_profile.dart';
import 'package:ojawa/faq_page.dart';

class ProfilePage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  const ProfilePage(
      {super.key,
      required this.goToProfilePage,
      required this.goToCategoriesPage,
      required this.goToOrdersPage});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List searchResults = [];
  bool searchLoading = false;
  bool _isSearching = false;
  final storage = const FlutterSecureStorage();
  int? _selectedRadioValue = 1;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  String? profileImg;
  String? userName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                        const Text('My Profile',
                            style: TextStyle(fontSize: 20)),
                        const Spacer(),
                        Container(
                          height: (40 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
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

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            if (profileImg == null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Container(
                                  width:
                                      (85 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (85 /
                                          MediaQuery.of(context).size.height) *
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
                                      (85 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (85 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  color: Colors.grey,
                                  child: Image.network(
                                    profileImg!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => EditProfile(
                            //             key: UniqueKey(),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     child: Image.asset(
                            //       height: 30,
                            //       'images/profile_edit.png',
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _phoneNumberController,
                            focusNode: _phoneNumberFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _locationController,
                            focusNode: _locationFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Location',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: Row(
                            children: [
                              filter('Male', 1),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              filter('Female', 2),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              filter('Other', 3)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget filter(String text, int value) {
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
}
