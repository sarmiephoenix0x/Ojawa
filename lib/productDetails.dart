import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ojawa/my_cart.dart';
import 'package:ojawa/write_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

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
  final List<Map<String, String>> products = [
    {
      'img': 'images/Img2.png',
      'details': 'Allen Solly Regular fit cotton shirt',
      'amount': '\$35',
      'slashedPrice': '\$40.25',
      'discount': '15% OFF',
      'starImg': 'images/Rating Icon.png',
      'rating': '4.4',
      'rating2': '(412)',
    },

    {
      'img': 'images/Img2.png',
      'details': 'Allen Solly Regular fit cotton shirt',
      'amount': '\$35',
      'slashedPrice': '\$40.25',
      'discount': '15% OFF',
      'starImg': 'images/Rating Icon.png',
      'rating': '4.4',
      'rating2': '(412)',
    },
    {
      'img': 'images/Img2.png',
      'details': 'Allen Solly Regular fit cotton shirt',
      'amount': '\$35',
      'slashedPrice': '\$40.25',
      'discount': '15% OFF',
      'starImg': 'images/Rating Icon.png',
      'rating': '4.4',
      'rating2': '(412)',
    },
    {
      'img': 'images/Img2.png',
      'details': 'Allen Solly Regular fit cotton shirt',
      'amount': '\$35',
      'slashedPrice': '\$40.25',
      'discount': '15% OFF',
      'starImg': 'images/Rating Icon.png',
      'rating': '4.4',
      'rating2': '(412)',
    },
    // Add more products here
  ];

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

  void _showReviewsSheet() {
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
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
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
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              reviewWidget(
                  5,
                  "Amazing!",
                  "An amazing fit. I am somewhere around 6ft and ordered 40 size, It's a perfect fit and quality is worth the price...",
                  "David Johnson",
                  "1st Jan 2020",
                  'images/Img5.png'),
              reviewWidget(
                  4,
                  "Fits Well!",
                  "Shirt is exactly as shown on the above picture. Perfect fitting as expected",
                  "Wade Johnson",
                  "15th Feb 2025",
                  ""),
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

  @override
  Widget build(BuildContext context) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      IconButton(
                        icon: Icon(
                          Icons.share_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: null,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
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
                Flexible(
                  child: ListView(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
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
                        items: imagePaths.map((item) {
                          return Image.asset(
                            item,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          );
                        }).toList(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
                        child: Text(
                          "Calvin Clein",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Calvin Clein Regular fit slim fit shirt",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/Rating Icon.png',
                              height: 25,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              '4.4',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              '87 Reviews',
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
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              '\$35',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.04),
                            Text(
                              '\$40.25',
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
                                    MediaQuery.of(context).size.width * 0.04),
                            Text(
                              '15% OFF',
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
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    width: MediaQuery.of(context).size.width *
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
                            const Text(
                              'Only 5 Left',
                              style: TextStyle(
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
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            imgList('images/Img5.png'),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    height: 2, // Thickness of the underline
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          height: MediaQuery.of(context).size.height * 0.04),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius:
                                BorderRadius.circular(12), // Smoother corners
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Options",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
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
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        width: 3, color: Color(0xFF1D4ED8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
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
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius:
                                BorderRadius.circular(12), // Smoother corners
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              product("Fabric", "Cotton"),
                              product("Length", "Regular"),
                              product("Neck", "Round Neck"),
                              product("Pattern", "Graphic Print"),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  color: Colors.grey,
                                  height: 20,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
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
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius:
                                BorderRadius.circular(12), // Smoother corners
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  color: Colors.grey,
                                  height: 20,
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
                                      '4.8',
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Overall Rating',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          const Text(
                                            '574 Ratings',
                                            overflow: TextOverflow.ellipsis,
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
                                            MediaQuery.of(context).size.height,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WriteReviewPage(
                                                        key: UniqueKey()),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.pressed)) {
                                                  return const Color(
                                                      0xFF1D4ED8);
                                                }
                                                return Colors.white;
                                              },
                                            ),
                                            foregroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.pressed)) {
                                                  return Colors.white;
                                                }
                                                return const Color(0xFF1D4ED8);
                                              },
                                            ),
                                            elevation:
                                                WidgetStateProperty.all<double>(
                                                    4.0),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 3,
                                                    color: Color(0xFF1D4ED8)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Rate',
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
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  color: Colors.grey,
                                  height: 20,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/star.png',
                                      height: 25,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Image.asset(
                                      'images/star.png',
                                      height: 25,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Image.asset(
                                      'images/star.png',
                                      height: 25,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Image.asset(
                                      'images/star.png',
                                      height: 25,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Image.asset(
                                      'images/star.png',
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  "Amazing!",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  "An amazing fit. I am somewhere around 6ft and ordered 40 size, It's a perfect fit and quality is worth the price...",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 3,
                                  style: TextStyle(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    imgList('images/Img5.png'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  "David Johnson, 1st Jan 2020",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  color: Colors.grey,
                                  height: 20,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    _showReviewsSheet();
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'View All 76 Reviews',
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
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
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
                              'You may like',
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
                          height: MediaQuery.of(context).size.height * 0.1),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCart(key: UniqueKey()),
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 3, color: Color(0xFF1D4ED8)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                        child: const Text(
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
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: (55 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
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
    return Image.asset(
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
                            _isLikedMap[img] = !isLiked;
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
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: List.generate(5, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: Image.asset(
                    'images/star.png',
                    height: 25,
                    color: index < starNum ? Colors.yellow : Colors.grey,
                  ),
                );
              }),
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
                fontSize: 20.0,
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
